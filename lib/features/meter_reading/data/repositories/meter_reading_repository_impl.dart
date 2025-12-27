import 'dart:io';
import 'package:smart_reader/core/developer.dart';

import '../../../../core/constants.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import '../../../../core/services/connectivity_service.dart';
import '../../../app_settings/domain/usecases/get_billing_settings_usecase.dart';
import '../../../auth/presentation/screens/splash_screen/app_billings_setting.dart';
import '../../domain/entities/meter_reading_entity.dart';
import '../../domain/repositories/meter_reading_repository.dart';
import '../data_source/meter_reading_local_data_source.dart';
import '../data_source/meter_reading_remote_data_source.dart';
import '../models/meter_reading_model.dart';
import '../services/upload_service.dart';

class MeterReadingRepositoryImpl implements MeterReadingRepository {
  final MeterReadingLocalDataSource local;
  final MeterReadingRemoteDataSource remote;
  final UploadService uploader;
  final GetBillingSettingsUseCase getSettings;

  final String _baseUrl = "http://192.168.1.150:3000/api";
  MeterReadingRepositoryImpl(
    this.local,
    this.remote,
    this.uploader,
    this.getSettings,
  );

  @override
  Future<ReadingSaveResult> addReading(
    MeterReadingEntity entity,
  ) async {
    final online = await ConnectivityService.isOnline();
    final readings = await local.getUserReading(entity.userId);
    final isFirstReading = readings.isEmpty;
    final lastReading = isFirstReading ? null : readings.last;

    final settings = AppBillingSettings.current;

    double cost = 0;
    double consumption = 0;


    if (!online && !isFirstReading) {
      consumption = entity.meterValue - lastReading!.meterValue;
      if (consumption < 0) {
        consumption = 0;
        cost = settings.minMonthlyFee;
      } else {
        cost = consumption * settings.pricePerKwh;
      }
    }

    final model = MeterReadingModel(
      idHive: entity.id,
      userIdHive: entity.userId,
      meterValueHive: entity.meterValue,
      consumptionHive: isFirstReading ? 0 : consumption,
      costHive: isFirstReading ? 0 : cost,
      pricePerKwhUsedHive:
      (!online && !isFirstReading) ? settings.pricePerKwh : 0,

      minMonthlyFeeUsedHive:
      (!online && !isFirstReading) ? settings.minMonthlyFee : 0,

      calculationModeUsedHive: isFirstReading
          ? 'initial'
          : online ? 'cloud' : 'local',
      settingsVersionUsedHive:
      (!online && !isFirstReading) ? settings.version : 0,
      timestampHive: entity.timestamp,
      imagePathHive: entity.imagePath,
      imageUrlHive: '',
      syncedHive: false,
      isDeletedHive: false,
    );
    await local.addReading(model);

    if(!online){
      if(isFirstReading){
        return ReadingSaveResult.initial(entity.meterValue);
      }
      return ReadingSaveResult.localCalculated(
        previousValue: lastReading!.meterValue,
        newValue: entity.meterValue,
        consumption: consumption,
        cost: cost,
      );
    }




    try {
      if (entity.imagePath.isEmpty) {
        throw Exception('Image path is empty');
      }
      final url = await uploader.uploadImage(entity.imagePath);
      final syncedModel = model.copyWith(
        imageUrlHive: url,
        imagePathHive: null,
        syncedHive: true,
      );

      await remote.addReading(syncedModel);
      await local.updateReading(syncedModel);

      if(!isFirstReading){
        try{
          await http.post(Uri.parse("$_baseUrl/calculate-reading"),
          body: jsonEncode({"readingId": entity.id}),
          headers: {"Content-Type": "application/json"},
          );

          AppLogger.info("Calculation request sent to server", tag: 'API_CALCULATION');
        }catch(serverError,stack){
          AppLogger.error("Server calculation trigger failed",error: serverError.toString(),
              stack: stack,
              tag: 'API_CALCULATION');
        }
      }

      if(isFirstReading){
        return ReadingSaveResult.initial(entity.meterValue);
      }


      return ReadingSaveResult.cloudPending(
        previousValue: lastReading!.meterValue,
        newValue: entity.meterValue,
        readingId: entity.id
      );

    } catch (e,stackTrace) {
      AppLogger.error(
    'Failed to add reading process',
    error: e,
    stack: stackTrace,
    tag: 'METER_REPOSITORY'
    );      throw Exception('Failed to sync reading: $e');
    }
  }

  @override
  Future<void> deleteReading(String id) async {
    final model = await local.getById(id);
    if (model == null) return;

    final online = await ConnectivityService.isOnline();
    if (online) {
      AppLogger.info('model is online');
      try {
        await remote.deleteReading(id);
        await local.deleteReading(id);
      } catch (e,stack) {
        AppLogger.error("Exception is  : ${e.toString()}",stack:stack );
      }
    } else {
      AppLogger.info('model is offline');

      final updated = model.copyWith(isDeletedHive: true);
      await local.updateReading(updated);
    }
  }

  @override
  Future<List<MeterReadingEntity>> getReadings(String userId) async {
    final online = await ConnectivityService.isOnline();
    if (!online) {
      final all = await local.getUserReading(userId);
      return all.where((r) => !r.isDeleted).toList();
    }
    await syncDeleteOffline(userId);

    try {
      final remoteList = await remote.getUserReading(userId);
      final localList = await local.getUserReading(userId);

      final localMap = {for (var r in localList) r.id: r};

      for (var remoteR in remoteList) {
        if (!localMap.containsKey(remoteR.id)) {
          await local.addReading(remoteR);
        }
      }


      final all = await local.getUserReading(userId);
      return all.where((r) => !r.isDeleted).toList();
    } catch (e) {
      final all = await local.getUserReading(userId);
      return all.where((r) => !r.isDeleted).toList();
    }
  }

  Future<void> syncDeleteOffline(String userId) async {
    final all = await local.getUserReading(userId);

    final needDelete = all.where((r) => r.isDeleted == true);

    for (var r in needDelete) {
      try {
        await remote.deleteReading(r.id);
        await local.deleteReading(r.id);
      } catch (_) {}
    }
  }



  @override
  Future<void> syncOffline(String userId) async {
    final online = await ConnectivityService.isOnline();
    if (!online) return;

    final all = await local.getUserReading(userId);

    for (var c in all) {
      if (!c.synced) {
        try {
          String? imageUrl;
          if (c.imagePath.isNotEmpty) {
            imageUrl = await uploader.uploadImage(c.imagePath);
          }

          final remoteModel = c.copyWith(
            imageUrlHive: imageUrl,
            imagePathHive: null,
            syncedHive: true,
          );

          await remote.addReading(remoteModel);
          final updatedLocal = c.copyWith(imageUrlHive: imageUrl, syncedHive: true);
          await local.updateReading(updatedLocal);
        } catch (e) {
          print('❌ syncOffline error for reading ${c.id}: $e');
        }
      }
    }
  }


  @override
  Stream<MeterReadingEntity> watchReading(String readingId) {
    return remote.listenToReading(readingId).where((model) {
      return model.costHive > 0 || model.calculationModeUsedHive == 'initial';
    },).asyncMap((model)async {
      await local.updateReading(model);
      return model;
    },);

  }




}

enum ReadingResultType { initial, localCalculated, cloudPending }

class ReadingSaveResult {
  final ReadingResultType type;
  final double? previousValue;
  final String? readingId;
  final double newValue;
  final double? consumption;
  final double? cost;

  const ReadingSaveResult.initial(this.newValue)
      : type = ReadingResultType.initial,
        previousValue = null,
        consumption = null,
        readingId = null,
        cost = null;

  const ReadingSaveResult.localCalculated({
    required this.previousValue,
    required this.newValue,
    this.readingId,
    required this.consumption,
    required this.cost,
  }) : type = ReadingResultType.localCalculated;

  const ReadingSaveResult.cloudPending({
    required this.readingId,
    required this.previousValue,
    required this.newValue,
  })  : type = ReadingResultType.cloudPending,
        consumption = null,
        cost = null;
}

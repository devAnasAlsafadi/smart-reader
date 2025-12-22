import 'dart:io';
import '../../../../core/constants.dart';

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


  MeterReadingRepositoryImpl(this.local, this.remote, this.uploader,    this.getSettings,);


  @override
  Future<ReadingCalculationResult> addReading(MeterReadingEntity entity) async {
    final lastReading = await local.getLastReading(entity.userId);
    final previousValue = lastReading?.meterValue ?? entity.meterValue;
    final consumption = entity.meterValue - previousValue;
    final settings = AppBillingSettings.current;
    final cost = consumption > 0
        ? consumption * settings.pricePerKwh
        : settings.minMonthlyFee;


    final model = MeterReadingModel(
      idHive: entity.id,
      userIdHive: entity.userId,
      meterValueHive: entity.meterValue,
      consumptionHive: consumption,
      costHive: cost,
      pricePerKwhUsedHive: settings.pricePerKwh,
      minMonthlyFeeUsedHive: settings.minMonthlyFee,
      calculationModeUsedHive: settings.calculationMode,
      settingsVersionUsedHive: settings.version,
      timestampHive: entity.timestamp,
      imagePathHive: entity.imagePath,
      imageUrlHive: '',
      syncedHive: false,
      isDeletedHive: false,
    );

    await local.addReading(model);

    final result = ReadingCalculationResult(
      previousValue: previousValue,
      newValue: entity.meterValue,
      consumption: consumption,
      cost: cost,
    );

    final online = await ConnectivityService.isOnline();
    if (!online) {
      return result;
    }


    try {
      final url = await UploadService().uploadImage(entity.imagePath);
      final remoteModel = model.copyWith(
        imageUrlHive: url,
        imagePathHive: null,
        syncedHive: true,
      );
      await remote.addReading(remoteModel);
      await remote.updateReading(remoteModel);
      final updatedLocal = model.copyWith(
        imageUrlHive: url,
        syncedHive: true,
      );
      await local.updateReading(updatedLocal);


    } catch (e) {
      print("Add reading error: $e");

    }
    return result;
  }

  @override
  Future<void> deleteReading(String id) async {
    final model = await local.getById(id);
    if (model == null) return;


    final online = await ConnectivityService.isOnline();
    if(online){
      try{
        await remote.deleteReading(id);
        await local.deleteReading(id);
      }
          catch(e){}
    }else{
      final updated = model.copyWith(
        isDeletedHive: true,
      );
      await local.updateReading(updated);
    }
  }

  @override
  Future<List<MeterReadingEntity>> getReadings(String customerId) async {

    final online = await ConnectivityService.isOnline();
    if (!online) {
      final all = await local.getCustomerReading(customerId);
      return all.where((r) => !r.isDeleted).toList();
    }
    await syncDeleteOffline(customerId);

    try{
      final remoteList = await remote.getCustomerReading(customerId);
      final localList = await local.getCustomerReading(customerId);

      final localMap = {for (var r in localList) r.id: r};

      for (var remoteR in remoteList) {
        if (!localMap.containsKey(remoteR.id)) {
          await local.addReading(remoteR);
        }
      }
      final all = await local.getCustomerReading(customerId);
      return all.where((r) => !r.isDeleted).toList();
    }
    catch(e){
      final all = await local.getCustomerReading(customerId);
      return all.where((r) => !r.isDeleted).toList();
    }

  }

  Future<void> syncDeleteOffline(String customerId) async {
    final all = await local.getCustomerReading(customerId);

    final needDelete = all.where(
          (r) => r.isDeleted == true,
    );

    for (var r in needDelete) {
      try {
        await remote.deleteReading(r.id);
        await local.deleteReading(r.id);
      } catch (_) {}
    }
  }

  @override
  Future<void> syncOffline(String customerId) async {
    final online = await ConnectivityService.isOnline();
    if (!online) return;

    final all = await local.getCustomerReading(customerId);

    for (var c in all) {
      if (!c.synced) {
        try {

          final url = await UploadService().uploadImage(c.imagePath);
          print("Uploaded to: $url");
          final remoteModel = c.copyWith(
            imageUrlHive: url,
            imagePathHive: null,
            syncedHive: true,
          );

          await remote.addReading(remoteModel);
          final updatedLocal = c.copyWith(
            imageUrlHive: url,
            syncedHive: true,
          );

          await local.updateReading(updatedLocal);
          await remote.updateReading(remoteModel);

        } catch (e) {
          print('error during sync: $e');
        }
      }
    }
  }
}
class ReadingCalculationResult {
  final double previousValue;
  final double newValue;
  final double consumption;
  final double cost;

  ReadingCalculationResult({
    required this.previousValue,
    required this.newValue,
    required this.consumption,
    required this.cost,
  });
}

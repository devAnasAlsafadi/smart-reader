

import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/developer.dart';
import 'package:smart_reader/features/meter_reading/data/models/meter_reading_model.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/listen_to_reading_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/sync_offline_readings_usecase.dart';
import '../../../../../core/constants.dart';
import 'meter_reading_event.dart';
import 'meter_reading_state.dart';
import '../../../domain/usecases/process_image_usecase.dart';
import '../../../domain/usecases/extract_digits_usecase.dart';
import '../../../domain/usecases/add_reading_usecase.dart';
import '../../../domain/usecases/get_readings_usecase.dart';
import '../../../domain/usecases/delete_reading_usecase.dart';
import '../../../domain/entities/meter_reading_entity.dart';

class MeterReadingBloc extends Bloc<MeterReadingEvent, MeterReadingState> {
  final ProcessImageUseCase processImage;
  final ExtractDigitsUseCase extractDigits;
  final AddReadingUseCase addReading;
  final ListenToReadingUsecase watchReading;
  final GetReadingsUseCase getReadings;
  final DeleteReadingUseCase deleteReading;
  final SyncOfflineReadingsUseCase syncOffline;

  MeterReadingBloc({
    required this.processImage,
    required this.extractDigits,
    required this.addReading,
    required this.getReadings,
    required this.deleteReading,
    required this.syncOffline,
    required this.watchReading,
  }) : super(OcrInitialState()) {

    on<ProcessImageEvent>((event, emit) async {
      emit(OcrProcessingState());
      try{
        AppLogger.info('text before is ${event.imageFile}');
        final text = await processImage(event.imageFile);
        AppLogger.info('text extracted is : ${text}');
        emit(OcrTextReadyState(text));
      }
      catch(e)
      {
        emit(OcrFailureState(e.toString()));
      }
    });

    // on<ExtractDigitsEvent>((event, emit) {
    //   final digits = extractDigits(event.rawText);
    //   emit(DigitsExtractedState(digits));
    // });

    on<SaveReadingEvent>((event, emit) async {
      emit(ReadingSavedLoadingState());
      try {
        final entity = MeterReadingEntity(
          id:event.entity.id,
          calculationModeUsed: event.entity.calculationModeUsed,
          minMonthlyFeeUsed: event.entity.minMonthlyFeeUsed,
          pricePerKwhUsed: event.entity.pricePerKwhUsed,
          settingsVersionUsed: event.entity.settingsVersionUsed,
          userId: event.entity.userId,
          meterValue: event.entity.meterValue,
          consumption: event.entity.consumption,
          cost: event.entity.cost,
          timestamp: DateTime.now(),
          imagePath: event.entity.imagePath,
          imageUrl: '',
          synced: false,
        );
        final result = await addReading(entity);

        emit(ReadingSavedSuccessState(result));

      } catch (e) {
        emit(ReadingSavedFailureState(e.toString()));
      }
    });



    on<LoadReadingsEvent>((event, emit) async {
      emit(ReadingsLoadingState());
      final list = await getReadings(event.userId);
      emit(ReadingsLoadedState(list));
    });


    on<DeleteReadingEvent>((event, emit) async {
      emit(ReadingLoadingDeleteState());
      await deleteReading(event.id);
      emit(ReadingDeletedSuccessState());
    });

    on<SyncOfflineReadingsEvent>((event, emit) async {
      await syncOffline(event.userId);
    });

    on<ListenToReadingEvent>((event, emit) async {
      await emit.forEach<MeterReadingEntity>(
        watchReading(event.readingId),
        onData: (reading) => ListenToReadingState(reading),
        onError: (error, stackTrace) {
          return ReadingSavedFailureState(error.toString());
          },
      );
    });
  }


}
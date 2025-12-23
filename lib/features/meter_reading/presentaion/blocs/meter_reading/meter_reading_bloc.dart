

import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
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
  }) : super(OcrInitialState()) {

    on<ProcessImageEvent>((event, emit) async {
      emit(OcrProcessingState());
      final text = await processImage(event.imageFile);
      emit(OcrTextReadyState(text));
    });

    on<ExtractDigitsEvent>((event, emit) {
      final digits = extractDigits(event.rawText);
      emit(DigitsExtractedState(digits));
    });

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
        print('enter try');
        final result = await addReading(entity);
        print('enter sucess');

        emit(ReadingSavedSuccessState(result));

      } catch (e) {
        print('enter failure');
        emit(ReadingSavedFailureState(e.toString()));
      }
    });



    on<LoadReadingsEvent>((event, emit) async {
      emit(ReadingsLoadingState());
      final list = await getReadings(event.userId);
      emit(ReadingsLoadedState(list));
    });


    on<DeleteReadingEvent>((event, emit) async {
      await deleteReading(event.id);
      emit(ReadingDeletedState());
    });

    on<SyncOfflineReadingsEvent>((event, emit) async {
      await syncOffline(event.userId);
    });

  }


}
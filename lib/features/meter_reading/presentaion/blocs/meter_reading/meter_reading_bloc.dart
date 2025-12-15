

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
          customerId: event.entity.customerId,
          meterValue: event.entity.meterValue,
          consumption: event.entity.consumption,
          cost: event.entity.cost,
          timestamp: DateTime.now(),
          imagePath: event.entity.imagePath,
          imageUrl: '',
          synced: false,
        );

        final result = await addReading(entity);
        print('cost is  : ${result.cost}');
        print('consumption is  : ${result.consumption}');
        print('previousValue is  : ${result.previousValue}');
        print('newValue is  : ${result.newValue}');

        emit(ReadingSavedSuccessState(result));

      } catch (e) {
        emit(ReadingSavedFailureState(e.toString()));
      }
    });


    on<LoadReadingsEvent>((event, emit) async {
      emit(ReadingsLoadingState());
      final list = await getReadings(event.customerId);
      emit(ReadingsLoadedState(list));
    });


    on<DeleteReadingEvent>((event, emit) async {
      await deleteReading(event.id);
      emit(ReadingDeletedState());
    });

    on<SyncOfflineReadingsEvent>((event, emit) async {
      await syncOffline(event.customerId);
    });

  }


}
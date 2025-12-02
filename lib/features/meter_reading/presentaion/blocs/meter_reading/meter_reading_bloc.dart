import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/save_reading_usecase.dart';

import '../../../data/services/image_picker_service.dart';
import '../../../domain/usecases/extract_digits_usecase.dart';
import '../../../domain/usecases/process_image_usecase.dart';

part 'meter_reading_event.dart';
part 'meter_reading_state.dart';

class MeterReadingBloc extends Bloc<MeterReadingEvent, MeterReadingState> {
  final ImagePickerService imagePickerService;
  final ProcessImageUseCase processImageUseCase;
  final ExtractDigitsUseCase extractDigitsUseCase;
  final SaveReadingUseCase saveReadingUseCase;

  MeterReadingBloc({
    required this.imagePickerService,
    required this.processImageUseCase,
    required this.extractDigitsUseCase,
    required this.saveReadingUseCase,
  }) : super(MeterReadingInitial()) {


    on<PickFromCameraEvent>((event, emit) async {
      emit(ImagePickingState());
      final File? image = await imagePickerService.pickFromCamera();
      if (image != null) {
        emit(ImagePickedSuccess(image));
      } else {
        emit(MeterReadingError("Failed to pick image from camera"));
      }
    });

    on<PickFromGalleryEvent>((event, emit) async {
      emit(ImagePickingState());
      final File? image = await imagePickerService.pickFromGallery();
      if (image != null) {
        emit(ImagePickedSuccess(image));
      } else {
        emit(MeterReadingError("Failed to pick image from Gallery"));
      }
    });


    on<ProcessImageEvent>((event, emit)async {
      emit(OcrProcessingState());
      final String extractedText = await processImageUseCase(event.imageFile);
      print('extractedText is : $extractedText');
      emit(OcrTextReadyState(extractedText));
    },);

    on<ExtractDigitsEvent>((event, emit) async {
      final digits = extractDigitsUseCase(event.extractedText);
      emit(DigitsExtractedState(digits));
    });

    on<SaveSelectedReadingEvent>((event, emit) async {
      try {
             emit(ReadingSavedLoadingState());
          final entity = MeterReadingEntity(
            reading: event.selectedReading,
            timestamp: DateTime.now(),
            imagePath: event.imagePath,
          );
        await saveReadingUseCase(entity);
        emit(ReadingSavedSuccessState());
      } catch (_) {
        emit(ReadingSavedFailureState("Failed to save reading"));
      }
    });

  }
}

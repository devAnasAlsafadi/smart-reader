import 'package:equatable/equatable.dart';
import '../../../data/repositories/meter_reading_repository_impl.dart';
import '../../../domain/entities/meter_reading_entity.dart';

abstract class MeterReadingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OcrInitialState extends MeterReadingState {}
class OcrProcessingState extends MeterReadingState {}
class OcrFailureState extends MeterReadingState {
  final String error;
  OcrFailureState(this.error);
  @override
  List<Object?> get props => [error];
}

class OcrTextReadyState extends MeterReadingState {
  final String rawText;
  OcrTextReadyState(this.rawText);

  @override
  List<Object?> get props => [rawText];
}

class DigitsExtractedState extends MeterReadingState {
  final List<String> digits;
  DigitsExtractedState(this.digits);

  @override
  List<Object?> get props => [digits];
}
class ReadingsLoadingState extends MeterReadingState {}
class ReadingsLoadedState extends MeterReadingState {
  final List<MeterReadingEntity> readings;
  ReadingsLoadedState(this.readings);

  @override
  List<Object?> get props => [readings];
}

class ReadingSavedLoadingState extends MeterReadingState {}
class ReadingSavedSuccessState extends MeterReadingState {

  final ReadingSaveResult result;
  ReadingSavedSuccessState(this.result);
}

class ReadingSavedFailureState extends MeterReadingState {
  final String message;
  ReadingSavedFailureState(this.message);

  @override
  List<Object?> get props => [message];
}



class ReadingDeletedSuccessState extends MeterReadingState {}
class ReadingLoadingDeleteState extends MeterReadingState {}
class ListenToReadingState extends MeterReadingState {
  final MeterReadingEntity? updatedReading;
  ListenToReadingState(this.updatedReading);
}

part of 'meter_reading_bloc.dart';

abstract class MeterReadingState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


 class MeterReadingInitial extends MeterReadingState {}

class ImagePickingState extends MeterReadingState {}
class ImagePickedSuccess extends MeterReadingState {
  final File image;

  ImagePickedSuccess(this.image);

  @override
  List<Object?> get props => [image];
}

class OcrProcessingState extends MeterReadingState {}

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

class MeterReadingError extends MeterReadingState {
  final String message;

  MeterReadingError(this.message);

  @override
  List<Object?> get props => [message];
}


class ReadingSavedLoadingState extends MeterReadingState {}
class ReadingSavedSuccessState extends MeterReadingState {}
class ReadingSavedFailureState extends MeterReadingState {
  final String message;

  ReadingSavedFailureState(this.message);

  @override
  List<Object?> get props => [message];
}




part of 'meter_reading_bloc.dart';

abstract class MeterReadingEvent  extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PickFromCameraEvent extends MeterReadingEvent{}
class PickFromGalleryEvent extends MeterReadingEvent{}
class ProcessImageEvent extends MeterReadingEvent {
  final File imageFile;
  ProcessImageEvent(this.imageFile);
  @override
  List<Object?> get props => [imageFile];
}
class ExtractDigitsEvent extends MeterReadingEvent {
  final String extractedText;

  ExtractDigitsEvent(this.extractedText);

  @override
  // TODO: implement props
  List<Object?> get props => [extractedText];
}


class SaveSelectedReadingEvent extends MeterReadingEvent {
 final String selectedReading;
 final String imagePath;

  SaveSelectedReadingEvent({
    required this.selectedReading,
    required this.imagePath,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [selectedReading,imagePath];
}
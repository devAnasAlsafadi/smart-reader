import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';

abstract class MeterReadingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class ProcessImageEvent extends MeterReadingEvent {
  final File imageFile;

  ProcessImageEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class ExtractDigitsEvent extends MeterReadingEvent {
  final String rawText;

  ExtractDigitsEvent(this.rawText);

  @override
  List<Object?> get props => [rawText];
}

class SaveReadingEvent extends MeterReadingEvent {
  final MeterReadingEntity entity;

  SaveReadingEvent({
    required this.entity
  });

  @override
  List<Object?> get props => [entity];
}

class LoadReadingsEvent extends MeterReadingEvent {
  final String userId;

  LoadReadingsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class DeleteReadingEvent extends MeterReadingEvent {
  final String id;

  DeleteReadingEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SyncOfflineReadingsEvent extends MeterReadingEvent {
  final String userId;
  SyncOfflineReadingsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ListenToReadingEvent extends MeterReadingEvent {
  final String readingId;
  ListenToReadingEvent(this.readingId);
}

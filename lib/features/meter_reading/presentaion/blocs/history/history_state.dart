import 'package:equatable/equatable.dart';
import '../../../domain/entities/meter_reading_entity.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<MapEntry<dynamic, MeterReadingEntity>> readings;

  HistoryLoaded(this.readings);

  @override
  List<Object?> get props => [readings];
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

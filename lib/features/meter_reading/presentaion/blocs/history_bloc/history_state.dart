import 'package:equatable/equatable.dart';
import 'package:smart_reader/features/users/domain/entities/user_entity.dart';
import '../../../../meter_reading/domain/entities/meter_reading_entity.dart';

class ReadingHistoryItem {
  final MeterReadingEntity reading;
  final UserEntity user;

  ReadingHistoryItem({
    required this.reading,
    required this.user,
  });
}

abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<ReadingHistoryItem> items;

  HistoryLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

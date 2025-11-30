import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_all_readings_usecase.dart';
import '../../../domain/usecases/delete_reading_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetAllReadingsUseCase getAllReadingsUseCase;
  final DeleteReadingUseCase deleteReadingUseCase;

  HistoryBloc({
    required this.getAllReadingsUseCase,
    required this.deleteReadingUseCase,
  }) : super(HistoryInitial()) {

    on<LoadHistoryEvent>((event, emit) async {
      emit(HistoryLoading());
      try {
        final readings = await getAllReadingsUseCase();
        emit(HistoryLoaded(readings));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<DeleteReadingEvent>((event, emit) async {
      try {
        await deleteReadingUseCase(event.key);
        final updated = await getAllReadingsUseCase();
        emit(HistoryLoaded(updated));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });
  }
}

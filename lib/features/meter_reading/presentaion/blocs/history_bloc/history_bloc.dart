import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/user_session.dart';
import '../../../../users/domain/usecases/get_users_usecase.dart';
import '../../../domain/usecases/delete_reading_usecase.dart';
import '../../../domain/usecases/get_readings_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetUsersUseCase getUsers;
  final GetReadingsUseCase getReadings;
  final DeleteReadingUseCase deleteReading;

  HistoryBloc({
    required this.getUsers,
    required this.getReadings,
    required this.deleteReading,
  }) : super(HistoryInitial()) {
    on<LoadAllReadingsEvent>((event, emit) async {
      emit(HistoryLoading());

      try {
        final users = await getUsers(EmployeeSession.employeeId);

        List<ReadingHistoryItem> items = [];

        for (var user in users) {
          final readings = await getReadings(user.id);

          for (var r in readings) {
            items.add(
              ReadingHistoryItem(
                reading: r,
                user: user,
              ),
            );
          }
        }

        // sort newest first
        items.sort(
              (a, b) => b.reading.timestamp.compareTo(a.reading.timestamp),
        );

        emit(HistoryLoaded(items));
      } catch (e) {
        emit(HistoryError("Failed to load history: $e"));
      }
    });

  }
}

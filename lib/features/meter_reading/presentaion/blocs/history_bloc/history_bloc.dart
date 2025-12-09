import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/user_session.dart';
import '../../../../customers/domain/repositories/customer_repository.dart';
import '../../../../customers/domain/usecases/get_customers_usecase.dart';
import '../../../../meter_reading/domain/repositories/meter_reading_repository.dart';
import '../../../domain/usecases/delete_reading_usecase.dart';
import '../../../domain/usecases/get_readings_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetCustomersUseCase getCustomers;
  final GetReadingsUseCase getReadings;
  final DeleteReadingUseCase deleteReading;

  HistoryBloc({
    required this.getCustomers,
    required this.getReadings,
    required this.deleteReading,
  }) : super(HistoryInitial()) {
    on<LoadAllReadingsEvent>((event, emit) async {
      emit(HistoryLoading());

      try {
        final customers = await getCustomers(UserSession.userId);

        List<ReadingHistoryItem> items = [];

        for (var customer in customers) {
          final readings = await getReadings(customer.id);

          for (var r in readings) {
            items.add(
              ReadingHistoryItem(
                reading: r,
                customer: customer,
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

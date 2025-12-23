import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../meter_reading/domain/usecases/get_readings_usecase.dart';
import '../../../domain/usecases/calculate_billing_useCase.dart';
import '../../../domain/usecases/get_payments_usecase.dart';

import 'billing_event.dart';
import 'billing_state.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  final GetReadingsUseCase getReadings;
  final GetPaymentsUseCase getPayments;
  final CalculateBillingUseCase calculateBilling;

  BillingBloc({
    required this.getReadings,
    required this.getPayments,
    required this.calculateBilling,
  }) : super(const BillingState()) {
    on<LoadBillingEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final readings = await getReadings(event.userId);
        final payments = await getPayments(event.userId);

        final result = await calculateBilling(
          readings: readings,
          payments: payments,
        );

        emit(
          state.copyWith(
            isLoading: false,
            summary: result.summary,
            monthly: result.monthly,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}

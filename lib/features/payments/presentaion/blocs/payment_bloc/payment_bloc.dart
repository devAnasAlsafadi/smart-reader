import 'package:bloc/bloc.dart';

import '../../../domain/usecases/add_payment_usecase.dart';
import '../../../domain/usecases/delete_payment_usecase.dart';
import '../../../domain/usecases/get_payments_usecase.dart';
import '../../../domain/usecases/sync_offline_payments_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final AddPaymentUseCase addPaymentUseCase;
  final GetPaymentsUseCase getPaymentsUseCase;
  final DeletePaymentUseCase deletePaymentUseCase;
  final SyncOfflinePaymentsUseCase syncOfflinePaymentsUseCase;

  PaymentBloc({
    required this.addPaymentUseCase,
    required this.getPaymentsUseCase,
    required this.deletePaymentUseCase,
    required this.syncOfflinePaymentsUseCase,
  }) : super(const PaymentState()) {

    on<LoadPaymentsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final list = await getPaymentsUseCase(event.customerId);
        emit(state.copyWith(isLoading: false, payments: list));
      } catch (e) {
        emit(state.copyWith(isLoading: false, loadError: e.toString()));
      }
    });

    on<AddPaymentEvent>((event, emit) async {
      emit(state.copyWith(isAdding: true));
      try {
        print('adding');
        await addPaymentUseCase(event.payment);
        print('added');
        emit(state.copyWith(isAdding: false, addSuccess: true));
      } catch (e) {
        emit(state.copyWith(isAdding: false, addError: e.toString()));
      }
    });

    on<DeletePaymentEvent>((event, emit) async {
      emit(state.copyWith(isDeleting: true));
      try {
        await deletePaymentUseCase(event.id);
        emit(state.copyWith(isDeleting: false, deleteSuccess: true));
      } catch (e) {
        emit(state.copyWith(isDeleting: false, deleteError: e.toString()));
      }
    });

    on<SyncPaymentsEvent>((event, emit) async {
      emit(state.copyWith(isSyncing: true));
      try {
        await syncOfflinePaymentsUseCase(event.customerId);
        emit(state.copyWith(isSyncing: false));
      } catch (e) {
        emit(state.copyWith(isSyncing: false, syncError: e.toString()));
      }
    });

  }
}

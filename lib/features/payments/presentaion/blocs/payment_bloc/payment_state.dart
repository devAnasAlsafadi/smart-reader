import 'package:equatable/equatable.dart';
import '../../../domain/entities/payment_entity.dart';

class PaymentState extends Equatable {
  final bool isLoading;
  final bool isAdding;
  final bool isDeleting;
  final bool isSyncing;

  final List<PaymentEntity> payments;

  final String? loadError;
  final String? addError;
  final String? deleteError;
  final String? syncError;

  final bool addSuccess;
  final bool deleteSuccess;

  const PaymentState({
    this.isLoading = false,
    this.isAdding = false,
    this.isDeleting = false,
    this.isSyncing = false,
    this.payments = const [],

    this.loadError,
    this.addError,
    this.deleteError,
    this.syncError,

    this.addSuccess = false,
    this.deleteSuccess = false,
  });

  PaymentState copyWith({
    bool? isLoading,
    bool? isAdding,
    bool? isDeleting,
    bool? isSyncing,
    List<PaymentEntity>? payments,
    String? loadError,
    String? addError,
    String? deleteError,
    String? syncError,
    bool? addSuccess,
    bool? deleteSuccess,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      isDeleting: isDeleting ?? this.isDeleting,
      isSyncing: isSyncing ?? this.isSyncing,

      payments: payments ?? this.payments,

      loadError: loadError,
      addError: addError,
      deleteError: deleteError,
      syncError: syncError,

      addSuccess: addSuccess ?? false,
      deleteSuccess: deleteSuccess ?? false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isAdding,
    isDeleting,
    isSyncing,
    payments,
    loadError,
    addError,
    deleteError,
    syncError,
    addSuccess,
    deleteSuccess,
  ];
}
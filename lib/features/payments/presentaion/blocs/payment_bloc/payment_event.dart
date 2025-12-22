import 'package:equatable/equatable.dart';

import '../../../domain/entities/payment_entity.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadPaymentsEvent extends PaymentEvent {
  final String userId;
  const LoadPaymentsEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class AddPaymentEvent extends PaymentEvent {
  final PaymentEntity payment;
  const AddPaymentEvent(this.payment);
  @override
  List<Object?> get props => [payment];
}

class DeletePaymentEvent extends PaymentEvent {
  final String id;
  const DeletePaymentEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class SyncPaymentsEvent extends PaymentEvent {
  final String userId;
  const SyncPaymentsEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}
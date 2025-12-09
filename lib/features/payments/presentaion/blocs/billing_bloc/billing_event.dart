import 'package:equatable/equatable.dart';

class BillingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class LoadBillingEvent extends BillingEvent {
  final String customerId;

  LoadBillingEvent(this.customerId);

  @override
  List<Object?> get props => [customerId];
}



import 'package:equatable/equatable.dart';

class BillingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class LoadBillingEvent extends BillingEvent {
  final String userId;

  LoadBillingEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}



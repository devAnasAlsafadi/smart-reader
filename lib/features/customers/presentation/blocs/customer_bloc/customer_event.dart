
import 'package:equatable/equatable.dart';
import '../../../../../core/enum/customer_filter_type.dart';
import '../../../domain/entities/customer_entity.dart';


abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}


class AddCustomerEvent extends CustomerEvent{
  final CustomerEntity customerEntity;
  const AddCustomerEvent(this.customerEntity);
  @override
  List<Object?> get props => [customerEntity];
}

class LoadCustomersEvent extends CustomerEvent {
  final String userId;
  const LoadCustomersEvent(this.userId);
  @override
  List<Object?> get props => [userId];

}

class ChangeFilterEvent extends CustomerEvent {
  final CustomerFilterType type;
  const ChangeFilterEvent(this.type);
  @override
  List<Object?> get props => [type];

}

class SearchCustomerEvent extends CustomerEvent {
  final String text;
  const SearchCustomerEvent(this.text);
  @override
  List<Object?> get props => [text];

}

class ResetFilterEvent extends CustomerEvent {}


class DeleteCustomerEvent extends CustomerEvent{
  final String customerId;
  const DeleteCustomerEvent(this.customerId);
  @override
  List<Object?> get props => [customerId];
}

class SyncOfflineCustomersEvent extends CustomerEvent{
  final String userId;
  const SyncOfflineCustomersEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}


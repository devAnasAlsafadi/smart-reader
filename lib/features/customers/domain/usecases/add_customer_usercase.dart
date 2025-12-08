import 'package:smart_reader/features/customers/domain/entities/customer_entity.dart';
import 'package:smart_reader/features/customers/domain/repositories/customer_repository.dart';

class AddCustomerUseCase{
  final CustomerRepository repository;
  AddCustomerUseCase(this.repository);

  Future<void> call (CustomerEntity entity) async {
    await repository.addCustomer(entity);
  }

}
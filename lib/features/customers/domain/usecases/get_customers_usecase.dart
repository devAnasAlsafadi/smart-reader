import 'package:smart_reader/features/customers/domain/entities/customer_entity.dart';

import '../repositories/customer_repository.dart';

class GetCustomersUseCase {
  final CustomerRepository repository;
  GetCustomersUseCase(this.repository);
  Future<List<CustomerEntity>> call(String userId) async {
    return await repository.getCustomers(userId);
  }

}
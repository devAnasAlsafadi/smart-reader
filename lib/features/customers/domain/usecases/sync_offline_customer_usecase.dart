import 'package:smart_reader/features/customers/domain/repositories/customer_repository.dart';

class SyncOfflineCustomersUseCase {
  final CustomerRepository repository;
  SyncOfflineCustomersUseCase(this.repository);
  Future<void> call(String userId) async {
    return await repository.syncOfflineCustomers(userId);
  }
}
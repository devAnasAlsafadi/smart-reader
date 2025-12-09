import '../repositories/payment_repositories.dart';

class SyncOfflinePaymentsUseCase {
  final PaymentRepository repository;
  SyncOfflinePaymentsUseCase(this.repository);

  Future<void> call(String customerId) {
    return repository.syncOffline(customerId);
  }
}

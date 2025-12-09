import '../entities/payment_entity.dart';
import '../repositories/payment_repositories.dart';

class GetPaymentsUseCase {
  final PaymentRepository repository;
  GetPaymentsUseCase(this.repository);

  Future<List<PaymentEntity>> call(String customerId) {
    return repository.getPayments(customerId);
  }
}

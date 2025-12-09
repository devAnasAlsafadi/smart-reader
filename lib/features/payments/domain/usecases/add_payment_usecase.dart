import '../entities/payment_entity.dart';
import '../repositories/payment_repositories.dart';

class AddPaymentUseCase {
  final PaymentRepository repository;
  AddPaymentUseCase(this.repository);

  Future<void> call(PaymentEntity entity) {
    return repository.addPayment(entity);
  }
}

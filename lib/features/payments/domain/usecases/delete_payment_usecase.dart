import '../repositories/payment_repositories.dart';

class DeletePaymentUseCase {
  final PaymentRepository repository;
  DeletePaymentUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deletePayment(id);
  }
}

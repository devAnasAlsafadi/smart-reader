import 'package:smart_reader/features/payments/domain/entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<void> addPayment(PaymentEntity entity);
  Future<List<PaymentEntity>> getPayments(String customerId);
  Future<void> deletePayment(String id);
  Future<void> syncOffline(String customerId);

}
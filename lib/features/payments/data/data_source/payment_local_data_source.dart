import 'package:hive/hive.dart';
import 'package:smart_reader/features/payments/data/model/payment_model.dart';

abstract class PaymentLocalDataSource {
  Future<void> addPayment(PaymentModel model);
  Future<List<PaymentModel>> getPayment(String customerId);
  Future<void> deletePayment(String id);
  Future<void> updatePayment(PaymentModel model);
  Future<PaymentModel?> getById(String PaymentId);
}


class PaymentLocalDataSourceImpl implements PaymentLocalDataSource{
  final Box<PaymentModel> box;
  PaymentLocalDataSourceImpl(this.box);

  @override
  Future<void> addPayment(PaymentModel model) async{
    await box.put(model.idHive, model);
  }

  @override
  Future<void> deletePayment(String id) async {
    await box.delete(id);
  }


  @override
  Future<List<PaymentModel>> getPayment(String customerId) async {
    return box.values.where((element) => element.userId == customerId,).toList();
  }


  @override
  updatePayment(PaymentModel model) async {
    await box.put(model.idHive, model);
  }


  @override
  Future<PaymentModel?> getById(String paymentId) async{
    try {
      return box.get(paymentId);
    } catch (_) {
      return null;
    }
  }

}
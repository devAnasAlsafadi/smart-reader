
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/payment_model.dart';

abstract class PaymentRemoteDataSource{
  Future<void> addPayment(PaymentModel model);
  Future<void> updatePayment(PaymentModel model);
  Future<void> deletePayment(String id);
  Future<List<PaymentModel>> getPayments(String customerId);
}


class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource{

  final collection = FirebaseFirestore.instance.collection('payments');


  @override
  Future<void> addPayment(PaymentModel model)async {
    try{
      await collection.doc(model.id).set(model.toJson());
    }catch (e){
      rethrow;
    }
  }

  @override
  Future<void> deletePayment(String id)async{

    try{
      await collection.doc(id).delete();
    }catch (e){
      rethrow;
    }
  }

  @override
  Future<List<PaymentModel>> getPayments(String customerId)async {

    try{
      final snap = await collection
          .where("customerId", isEqualTo: customerId)
          .get();
      return  snap.docs.map((e) => PaymentModel.fromJson(e.data()),).toList();
    }catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePayment(PaymentModel model) async{

    try{
      await collection.doc(model.id).update(model.toJson());
    }catch (e){

      rethrow;
    }

  }

}
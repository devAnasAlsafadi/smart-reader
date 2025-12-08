
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_reader/features/meter_reading/data/models/meter_reading_model.dart';

abstract class MeterReadingRemoteDataSource{
  Future<void> addReading(MeterReadingModel model);
  Future<void> updateReading(MeterReadingModel model);
  Future<void> deleteReading(String id);
  Future<List<MeterReadingModel>> getCustomerReading(String customerId);
}


class MeterReadingRemoteDataSourceImpl implements MeterReadingRemoteDataSource{

  final collection = FirebaseFirestore.instance.collection('meter_readings');


  @override
  Future<void> addReading(MeterReadingModel model)async {
    try{
      await collection.doc(model.id).set(model.toJson());
    }catch (e){
      rethrow;
    }
  }

  @override
  Future<void> deleteReading(String id)async{

    try{
      await collection.doc(id).delete();
    }catch (e){
      rethrow;
    }
  }

  @override
  Future<List<MeterReadingModel>> getCustomerReading(String customerId)async {

    try{
      final snap = await collection
        .where("customerId", isEqualTo: customerId)
        .get();
      return  snap.docs.map((e) => MeterReadingModel.fromJson(e.data()),).toList();
    }catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateReading(MeterReadingModel model) async{

    try{
      await collection.doc(model.id).update(model.toJson());
    }catch (e){

      rethrow;
    }

  }

}
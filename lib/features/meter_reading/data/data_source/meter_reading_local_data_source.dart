

import 'package:hive/hive.dart';
import 'package:smart_reader/features/meter_reading/data/models/meter_reading_model.dart';

abstract class MeterReadingLocalDataSource {
  Future<void> addReading(MeterReadingModel model);
  Future<List<MeterReadingModel>> getCustomerReading(String customerId);
  Future<void> deleteReading(String id);
  Future<void> updateReading(MeterReadingModel model);
  Future<MeterReadingModel?> getById(String meterReadingId);
  Future<MeterReadingModel?> getLastReading(String customerId);

}


class MeterReadingLocalDataSourceImpl implements MeterReadingLocalDataSource{
  final Box<MeterReadingModel> box;
  MeterReadingLocalDataSourceImpl(this.box);
  @override
  Future<void> addReading(MeterReadingModel model)async {
    await box.put(model.idHive, model);
  }

  @override
  Future<void> deleteReading(String id) async{
    await box.delete(id);
  }

  @override
  Future<List<MeterReadingModel>> getCustomerReading(String customerId)async {
    return  box.values.where((element) => element.userId == customerId,).toList();
  }

  @override
  Future<void> updateReading(MeterReadingModel model)async {
    await box.put(model.idHive, model);
  }

  @override
  Future<MeterReadingModel?> getById(String meterReadingId) async{
    try {
      return box.get(meterReadingId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<MeterReadingModel?> getLastReading(String customerId) async {
    final readings = box.values
        .where((e) => e.userId == customerId && !e.isDeleted)
        .toList();

    if (readings.isEmpty) return null;

    readings.sort(
          (a, b) => b.timestamp.compareTo(a.timestamp),
    );

    return readings.first;
  }

}
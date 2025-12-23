

import 'package:hive/hive.dart';
import 'package:smart_reader/features/meter_reading/data/models/meter_reading_model.dart';

abstract class MeterReadingLocalDataSource {
  Future<void> addReading(MeterReadingModel model);
  Future<List<MeterReadingModel>> getUserReading(String userId);
  Future<void> deleteReading(String id);
  Future<void> updateReading(MeterReadingModel model);
  Future<MeterReadingModel?> getById(String meterReadingId);
  Future<MeterReadingModel?> getLastReading(String userId);

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
  Future<List<MeterReadingModel>> getUserReading(String userId) async {
    final list = box.values
        .where((e) => e.userId == userId && !e.isDeleted)
        .toList();

    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
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
  Future<MeterReadingModel?> getLastReading(String userId) async {
    final list = await getUserReading(userId);
    return list.isEmpty ? null : list.last;
  }
}
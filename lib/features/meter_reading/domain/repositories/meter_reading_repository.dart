import '../entities/meter_reading_entity.dart';

abstract class MeterReadingRepository {
  Future<void> addReading(MeterReadingEntity entity);
  Future<List<MeterReadingEntity>> getReadings(String customerId);
  Future<void> deleteReading(String id);
  Future<void> syncOffline(String customerId);

}
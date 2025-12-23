import '../../data/repositories/meter_reading_repository_impl.dart';
import '../entities/meter_reading_entity.dart';

abstract class MeterReadingRepository {
  Future<ReadingSaveResult> addReading(MeterReadingEntity entity);
  Future<List<MeterReadingEntity>> getReadings(String userId);
  Future<void> deleteReading(String id);
  Future<void> syncOffline(String userId);

}
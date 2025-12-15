import '../../data/repositories/meter_reading_repository_impl.dart';
import '../entities/meter_reading_entity.dart';

abstract class MeterReadingRepository {
  Future<ReadingCalculationResult> addReading(MeterReadingEntity entity);
  Future<List<MeterReadingEntity>> getReadings(String customerId);
  Future<void> deleteReading(String id);
  Future<void> syncOffline(String customerId);

}
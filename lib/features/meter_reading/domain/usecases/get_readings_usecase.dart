import '../entities/meter_reading_entity.dart';
import '../repositories/meter_reading_repository.dart';

class GetReadingsUseCase {
  final MeterReadingRepository repo;

  GetReadingsUseCase(this.repo);

  Future<List<MeterReadingEntity>> call(String customerId) async {
    return await repo.getReadings(customerId);
  }
}

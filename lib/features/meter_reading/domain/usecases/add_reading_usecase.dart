import '../entities/meter_reading_entity.dart';
import '../repositories/meter_reading_repository.dart';

class AddReadingUseCase {
  final MeterReadingRepository repo;

  AddReadingUseCase(this.repo);

  Future<void> call(MeterReadingEntity entity) async {
    return await repo.addReading(entity);
  }
}

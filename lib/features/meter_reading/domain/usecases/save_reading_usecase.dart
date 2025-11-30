import '../../data/repositories/meter_reading_repository..dart';
import '../entities/meter_reading_entity.dart';

class SaveReadingUseCase {
  final MeterReadingRepository repository;

  SaveReadingUseCase(this.repository);

  Future<void> call(MeterReadingEntity reading) async {
    await repository.saveReading(reading);
  }
}

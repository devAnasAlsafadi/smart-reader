import '../entities/meter_reading_entity.dart';
import '../repositories/meter_reading_repository.dart';

class ListenToReadingUsecase {
  final MeterReadingRepository repo;

  ListenToReadingUsecase(this.repo);

  Stream<MeterReadingEntity> call(String customerId) {
    return  repo.watchReading(customerId);
  }
}

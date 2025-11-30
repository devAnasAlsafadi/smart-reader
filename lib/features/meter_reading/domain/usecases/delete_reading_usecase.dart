
import '../../data/repositories/meter_reading_repository..dart';

class DeleteReadingUseCase {
  final MeterReadingRepository repository;

  DeleteReadingUseCase(this.repository);


  Future<void> call(dynamic key) async {
    await repository.deleteReading(key);
  }
}
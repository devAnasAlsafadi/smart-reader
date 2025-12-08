import '../repositories/meter_reading_repository.dart';

class DeleteReadingUseCase {
  final MeterReadingRepository repo;

  DeleteReadingUseCase(this.repo);

  Future<void> call(String id) async {
    return await repo.deleteReading(id);
  }
}

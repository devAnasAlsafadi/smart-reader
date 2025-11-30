import '../../data/repositories/meter_reading_repository..dart';
import '../entities/meter_reading_entity.dart';

class GetAllReadingsUseCase {
  final MeterReadingRepository repository;

  GetAllReadingsUseCase(this.repository);

  Future<List<MapEntry<dynamic, MeterReadingEntity>>> call() async {
    return await repository.getAllReadings();
  }
}
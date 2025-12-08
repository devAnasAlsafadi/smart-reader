import '../repositories/meter_reading_repository.dart';

class SyncOfflineReadingsUseCase {
  final MeterReadingRepository repo;

  SyncOfflineReadingsUseCase(this.repo);

  Future<void> call(String customerId) async {
    return await repo.syncOffline(customerId);
  }
}

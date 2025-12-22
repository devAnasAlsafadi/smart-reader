import '../repositories/app_settings_repository.dart';

class SyncBillingSettingsUseCase {
  final AppSettingsRepository repo;

  SyncBillingSettingsUseCase(this.repo);

  Future<void> call() {
    return repo.syncSettings();
  }
}

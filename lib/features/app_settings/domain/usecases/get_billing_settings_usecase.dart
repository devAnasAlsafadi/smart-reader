import '../entities/billing_settings_entity.dart';
import '../repositories/app_settings_repository.dart';

class GetBillingSettingsUseCase {
  final AppSettingsRepository repo;

  GetBillingSettingsUseCase(this.repo);

  Future<BillingSettingsEntity> call() {
    return repo.getSettings();
  }
}

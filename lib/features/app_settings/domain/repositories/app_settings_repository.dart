import '../../domain/entities/billing_settings_entity.dart';

abstract class AppSettingsRepository {
  Future<BillingSettingsEntity> getSettings();
  Future<void> syncSettings();
}
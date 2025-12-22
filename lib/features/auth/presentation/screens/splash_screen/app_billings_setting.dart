import '../../../../app_settings/domain/entities/billing_settings_entity.dart';

class AppBillingSettings {
  static BillingSettingsEntity? _current;

  static BillingSettingsEntity get current {
    if (_current == null) {
      throw Exception('BillingSettings not initialized');
    }
    return _current!;
  }

  static void set(BillingSettingsEntity settings) {
    _current = settings;
  }
}

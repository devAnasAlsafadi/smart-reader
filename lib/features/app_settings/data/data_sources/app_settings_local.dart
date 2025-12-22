import 'package:hive/hive.dart';

import '../models/billing_settings_model.dart';

abstract class AppSettingsLocalDataSource {
  Future<void> save(BillingSettingsModel model);
  Future<BillingSettingsModel?> get();
}

class AppSettingsLocalDataSourceImpl
    implements AppSettingsLocalDataSource {

  final Box<BillingSettingsModel> box;
  AppSettingsLocalDataSourceImpl(this.box);

  static const _key = 'billing_settings';

  @override
  Future<void> save(BillingSettingsModel model) async {
    await box.put(_key, model);
  }

  @override
  Future<BillingSettingsModel?> get() async {
    return box.get(_key);
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../app_settings/domain/usecases/get_billing_settings_usecase.dart';
import '../../../../app_settings/domain/usecases/sync_billing_settings_usecase.dart';
import '../../../data/models/employee_model.dart';
import 'app_billings_setting.dart';

class SplashScreenController {

  final GetBillingSettingsUseCase getBillingSettings;
  final SyncBillingSettingsUseCase syncBillingSettings;

  SplashScreenController({
    required this.getBillingSettings,
    required this.syncBillingSettings,
  });


  Future<void> startApp(BuildContext context) async {

    final settings = await getBillingSettings();
    AppBillingSettings.set(settings);
    
    bool online = await ConnectivityService.isOnline();
    if (online) {
      unawaited(syncBillingSettings());
    }


    await Future.delayed(const Duration(seconds: 2));
    final box = Hive.box<EmployeeModel>("employee_box");
    final employee = box.get("employee");

    if (employee != null && employee.token!.isNotEmpty) {
      NavigationManger.navigateAndReplace(context, RouteNames.home);
    } else {
      NavigationManger.navigateAndReplace(context, RouteNames.login);
    }
  }
}
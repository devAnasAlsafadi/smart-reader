import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_reader/app.dart';
import 'package:smart_reader/core/utils/app_assets.dart';
import 'package:smart_reader/features/app_settings/data/models/billing_settings_model.dart';
import 'package:smart_reader/features/electrical_panels/data/models/electrical_panel_model.dart';
import 'package:smart_reader/features/meter_reading/data/models/meter_reading_model.dart';
import 'package:smart_reader/features/payments/data/model/payment_model.dart';
import 'package:smart_reader/features/users/data/models/user_model.dart';

import 'SimpleBlocObserver.dart';
import 'features/auth/data/models/employee_model.dart';
import 'features/meter_reading/data/services/meter_ocr_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = SimpleBlocObserver();
  final ocrService = MeterOcrService();
  await ocrService.initModel();
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(MeterReadingModelAdapter());
  Hive.registerAdapter(ElectricalPanelModelAdapter());
  Hive.registerAdapter(PaymentModelAdapter());
  Hive.registerAdapter(BillingSettingsModelAdapter());
  await Hive.openBox<EmployeeModel>("employee_box");
  await Hive.openBox<UserModel>("user_box");
  await Hive.openBox<MeterReadingModel>("meter_reading_box");
  await Hive.openBox<PaymentModel>("payment_box");
  await Hive.openBox<ElectricalPanelModel>("panel_box");
  await Hive.openBox<BillingSettingsModel>("settings_box");

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale("ar")],
      fallbackLocale: Locale('en'),
      // startLocale: const Locale('ar'),
      path: AppAssets.translations,
      child:  SmartReaderApp(ocrService),
    ),
  );
}

/*
dart run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart
 */
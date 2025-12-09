import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_reader/app.dart';
import 'package:smart_reader/features/meter_reading/data/models/meter_reading_model.dart';
import 'package:smart_reader/features/payments/data/model/payment_model.dart';

import 'SimpleBlocObserver.dart';
import 'features/auth/data/models/user_model.dart';
import 'features/customers/data/models/customer_model.dart';
import 'firebase_options.dart';



void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(CustomerModelAdapter());
  Hive.registerAdapter(MeterReadingModelAdapter());
  Hive.registerAdapter(PaymentModelAdapter());
  await Hive.openBox<UserModel>("user_box");
  await Hive.openBox<CustomerModel>("customer_box");
  await Hive.openBox<MeterReadingModel>("meter_reading_box");
  await Hive.openBox<PaymentModel>("payment_box");

  runApp(const SmartReaderApp());


}





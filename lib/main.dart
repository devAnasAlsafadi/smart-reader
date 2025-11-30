import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_reader/app.dart';
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';

import 'SimpleBlocObserver.dart';
import 'firebase_options.dart';

void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  await Hive.initFlutter();
  Hive.registerAdapter(MeterReadingEntityAdapter());
  runApp(const SmartReaderApp());


}


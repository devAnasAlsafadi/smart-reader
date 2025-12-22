import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/features/auth/presentation/screens/login_screen/login_screen.dart';
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/camera_screen/camera_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/extract_reading_screen/extract_reading_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/guide_screen/guide_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/history_screen/history_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/preview_screen/preview_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/result_screen/result_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/settings_screen.dart';

import '../../features/app_settings/domain/usecases/get_billing_settings_usecase.dart';
import '../../features/app_settings/domain/usecases/sync_billing_settings_usecase.dart';
import '../../features/auth/presentation/screens/splash_screen/splash_screen.dart';
import '../../features/meter_reading/presentaion/screens/edit_reading_screen/edit_reading_screen.dart';
import '../../features/users/domain/entities/user_entity.dart';
import '../../features/users/presentation/screens/add_user_screen/add_user_screen.dart';
import '../../features/users/presentation/screens/user_details_screen/user_details_screen.dart';
import '../../features/users/presentation/screens/home_screen/home_screen.dart';



class AppRouter {

  final GetBillingSettingsUseCase getBillingSettings;
  final SyncBillingSettingsUseCase syncBillingSettings;

  AppRouter({
    required this.getBillingSettings,
    required this.syncBillingSettings,
  });
   Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen(getBillingSettings: getBillingSettings,syncBillingSettings: syncBillingSettings,));
      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) =>  SettingsScreen());
      case RouteNames.camera:
        final userId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) =>  CameraScreen(userId: userId,));
      case RouteNames.userDetails:
        final entity = settings.arguments as UserEntity ;
        return MaterialPageRoute(builder: (_) =>  UserDetailsScreen(user: entity,));
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) =>  HomeScreen());
      case RouteNames.guide:
        return MaterialPageRoute(builder: (_) => const GuideScreen());
      case RouteNames.addUserScreen:
        return MaterialPageRoute(builder: (_) => const AddUserScreen());
      case RouteNames.preview:
        final args = settings.arguments as Map<String, dynamic>;
        final imageFile = args['imageFile'] as File ;
        final userId = args['userId'] as String;
        return MaterialPageRoute(builder: (_) =>  PreviewScreen(imageFile: imageFile,userId: userId,));
      case RouteNames.result:
        final entity =  settings.arguments  as MeterReadingEntity;
        return MaterialPageRoute(builder: (_) =>  ResultScreen(entity: entity,));
      case RouteNames.history:
              return MaterialPageRoute(builder: (_) =>  HistoryScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) =>  LoginScreen());
      case RouteNames.editReadingScreen:
        final meterValue = settings.arguments as double;
        return MaterialPageRoute(builder: (_) =>  EditReadingScreen(initialReading: meterValue,));
      case RouteNames.extractReadingScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final readings = args['readings'] as List<String>;
        final entity = args['entity'] as MeterReadingEntity;
        final rawText = args['rawText'] as String;
        return MaterialPageRoute(builder: (_) =>  ExtractReadingScreen(readings: readings, rawText: rawText, entity: entity,));

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

}

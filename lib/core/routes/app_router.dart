import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/features/auth/presentation/screens/login_screen/login_screen.dart';
import 'package:smart_reader/features/customers/domain/entities/customer_entity.dart';
import 'package:smart_reader/features/customers/presentation/screens/add_customer_screen/add_customer_screen.dart';
import 'package:smart_reader/features/customers/presentation/screens/customer_details_screen/customer_details_screen.dart';
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/camera_screen/camera_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/extract_reading_screen/extract_reading_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/guide_screen/guide_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/history_screen/history_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/preview_screen/preview_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/result_screen/result_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/settings_screen.dart';

import '../../features/auth/presentation/screens/splash_screen/splash_screen.dart';
import '../../features/customers/presentation/screens/home_screen/home_screen.dart';
import '../../features/meter_reading/presentaion/screens/edit_reading_screen/edit_reading_screen.dart';



class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) =>  SettingsScreen());
      case RouteNames.camera:
        final customerId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) =>  CameraScreen(customerId: customerId,));
      case RouteNames.customerDetails:
        final entity = settings.arguments as CustomerEntity ;
        return MaterialPageRoute(builder: (_) =>  CustomerDetailsScreen(customer: entity,));
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) =>  HomeScreen());
      case RouteNames.guide:
        return MaterialPageRoute(builder: (_) => const GuideScreen());
      case RouteNames.addCustomerScreen:
        return MaterialPageRoute(builder: (_) => const AddCustomerScreen());
      case RouteNames.preview:
        final args = settings.arguments as Map<String, dynamic>;
        final imageFile = args['imageFile'] as File ;
        final customerId = args['customerId'] as String;
        return MaterialPageRoute(builder: (_) =>  PreviewScreen(imageFile: imageFile,customerId: customerId,));
      case RouteNames.result:
        final entity =  settings.arguments  as MeterReadingEntity;
        return MaterialPageRoute(builder: (_) =>  ResultScreen(entity: entity,));
      case RouteNames.history:
              return MaterialPageRoute(builder: (_) =>  HistoryScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) =>  LoginScreen());
      case RouteNames.editReadingScreen:
        final reading = settings.arguments as String;
        return MaterialPageRoute(builder: (_) =>  EditReadingScreen(initialReading: reading,));
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

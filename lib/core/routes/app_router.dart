import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/camera_screen/camera_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/extract_reading_screen/extract_reading_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/guide_screen/guide_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/history_screen/history_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/preview_screen/preview_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/result_screen/result_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/settings_screen.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/splash_screen/splash_screen.dart';

import '../../features/meter_reading/presentaion/screens/edit_reading_screen/edit_reading_screen.dart';
import '../../features/meter_reading/presentaion/screens/home_screen/home_screen.dart';



class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) =>  SettingsScreen());
      case RouteNames.camera:
        return MaterialPageRoute(builder: (_) => const CameraScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteNames.guide:
        return MaterialPageRoute(builder: (_) => const GuideScreen());
      case RouteNames.preview:
        final imageFile = settings.arguments as File ;
        return MaterialPageRoute(builder: (_) =>  PreviewScreen(imageFile: imageFile,));
      case RouteNames.result:
        final args = settings.arguments as Map<String, dynamic>;

        final reading = args['reading'] as String;
        final imagePath = args['imagePath'] as String;
        return MaterialPageRoute(builder: (_) =>  ResultScreen(reading:reading, imagePath: imagePath,));
      case RouteNames.history:
              return MaterialPageRoute(builder: (_) =>  HistoryScreen());
      case RouteNames.editReadingScreen:
        final reading = settings.arguments as String;
        return MaterialPageRoute(builder: (_) =>  EditReadingScreen(initialReading: reading,));
      case RouteNames.extractReadingScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final readings = args['readings'] as List<String>;
        final rawText = args['rawText'] as String;
        final imagePath = args['imagePath'] as String;
        return MaterialPageRoute(builder: (_) =>  ExtractReadingScreen(readings: readings, rawText: rawText, imagePath: imagePath));

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

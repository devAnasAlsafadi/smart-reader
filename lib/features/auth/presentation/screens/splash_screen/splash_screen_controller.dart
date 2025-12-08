import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../data/models/user_model.dart';

class SplashScreenController {
  Future<void> startApp(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    final box = Hive.box<UserModel>("user_box");
    final user = box.get("user");

    if (user != null && user.token.isNotEmpty) {
      NavigationManger.navigateAndReplace(context, RouteNames.home);
    } else {
      NavigationManger.navigateAndReplace(context, RouteNames.login);
    }
  }
}
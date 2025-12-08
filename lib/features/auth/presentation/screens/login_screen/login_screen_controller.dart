import 'package:flutter/cupertino.dart';

import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';

class LoginScreenController {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;


  LoginScreenController();

  void togglePasswordVisibility(){
    obscurePassword =! obscurePassword;
    iconPassword =  obscurePassword ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill;
  }
  void onSuccessLogin(BuildContext context) {
    NavigationManger.navigateAndReplace(context, RouteNames.home);
  }

  void dispose(){
    passwordController.dispose();
    emailController.dispose();
  }


}
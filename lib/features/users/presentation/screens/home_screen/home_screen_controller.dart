// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/user_session.dart';

import '../../blocs/user_bloc/user_bloc.dart';
import '../../blocs/user_bloc/user_event.dart';



class HomeScreenController {
  final searchCtrl = TextEditingController();
  final searchFocus = FocusNode();

  void init(BuildContext context) {
    context
      ..read<UserBloc>()
          .add(LoadUsersEvent(EmployeeSession.employeeId))
      ..read<UserBloc>()
          .add(SyncOfflineUsersEvent(EmployeeSession.employeeId));
  }

  void dispose() {
    searchCtrl.dispose();
    searchFocus.dispose();
  }

  void onSearch(String txt, BuildContext context) {
    context.read<UserBloc>().add(SearchUserEvent(txt));
  }

  void onOpenSettings(BuildContext context) {
    searchFocus.unfocus();
    Future.delayed(const Duration(milliseconds: 200), () {
      NavigationManger.navigateTo(context, RouteNames.settings);
    });
  }

  void resetFocus() {
    searchFocus.unfocus();
  }
}

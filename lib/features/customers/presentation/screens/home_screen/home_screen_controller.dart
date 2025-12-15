// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/user_session.dart';

// Features – Customers
import 'package:smart_reader/features/customers/presentation/blocs/customer_bloc/customer_bloc.dart';
import 'package:smart_reader/features/customers/presentation/blocs/customer_bloc/customer_event.dart';


class HomeScreenController {
  final searchCtrl = TextEditingController();
  final searchFocus = FocusNode();

  void init(BuildContext context) {
    context
      ..read<CustomerBloc>()
          .add(LoadCustomersEvent(UserSession.userId))
      ..read<CustomerBloc>()
          .add(SyncOfflineCustomersEvent(UserSession.userId));
  }

  void dispose() {
    searchCtrl.dispose();
    searchFocus.dispose();
  }

  void onSearch(String txt, BuildContext context) {
    context.read<CustomerBloc>().add(SearchCustomerEvent(txt));
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

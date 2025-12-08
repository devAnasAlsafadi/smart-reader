import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/user_session.dart';
import '../../blocs/customer_bloc/customer_bloc.dart';
import '../../blocs/customer_bloc/customer_event.dart';

class HomeScreenController  {
  final searchCtrl = TextEditingController();
  final searchFocus = FocusNode();

void init(BuildContext context) {
    context.read<CustomerBloc>().add(LoadCustomersEvent(UserSession.userId));
    context.read<CustomerBloc>().add(SyncOfflineCustomersEvent(UserSession.userId));
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
      Navigator.pushNamed(context, "/settings");
    });
  }

  void resetFocus() {
    searchFocus.unfocus();
  }


}
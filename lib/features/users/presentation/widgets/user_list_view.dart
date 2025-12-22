import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/user_session.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

import '../blocs/user_bloc/user_bloc.dart';
import '../blocs/user_bloc/user_event.dart';
import '../blocs/user_bloc/user_state.dart';
import 'user_card.dart';

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        print('state.filteredUsers.length is : ${state.filteredUsers.length}');
        if (state.isLoadingGet) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.filteredUsers.isEmpty) {
          return Center(child: Text(LocaleKeys.no_users_found.t));
        }
        return AnimationLimiter(
          child: ListView.builder(
            itemCount: state.filteredUsers.length,
            itemBuilder: (_, i) {
              final c = state.filteredUsers[i];
              return AnimationConfiguration.staggeredList(
                position: i,
                duration: const Duration(milliseconds: 300),
                child: SlideAnimation(
                  verticalOffset: 40,
                  curve: Curves.easeOut,
                  child: FadeInAnimation(
                    child: UserCard(
                      name: c.name,
                      city: c.address,
                      street: c.street,
                      onTap: () async {
                        await NavigationManger.navigateTo(
                          context,
                          RouteNames.userDetails,
                          arguments: c,
                        );
                        context.read<UserBloc>().add(
                          LoadUsersEvent(EmployeeSession.employeeId),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

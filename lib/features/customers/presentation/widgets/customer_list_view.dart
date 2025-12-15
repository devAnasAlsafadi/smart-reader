import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/user_session.dart';
import 'package:smart_reader/features/customers/presentation/blocs/customer_bloc/customer_event.dart';
import '../blocs/customer_bloc/customer_bloc.dart';
import '../blocs/customer_bloc/customer_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

import 'customer_card.dart';

class CustomerListView extends StatelessWidget {
  const CustomerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state.isLoadingGet) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.filteredCustomers.isEmpty) {
          return Center(child: Text(LocaleKeys.no_customers_found.tr()));
        }
        return AnimationLimiter(
          child: ListView.builder(
            itemCount: state.filteredCustomers.length,
            itemBuilder: (_, i) {
              final c = state.filteredCustomers[i];
              return AnimationConfiguration.staggeredList(
                position: i,
                duration: const Duration(milliseconds: 300),
                child: SlideAnimation(
                  verticalOffset: 40,
                  curve: Curves.easeOut,
                  child: FadeInAnimation(
                    child: CustomerCard(
                      name: c.name,
                      city: c.address,
                      street: c.street,
                      onTap: () async {
                        await NavigationManger.navigateTo(
                          context,
                          RouteNames.customerDetails,
                          arguments: c,
                        );
                        context.read<CustomerBloc>().add(
                          LoadCustomersEvent(UserSession.userId),
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

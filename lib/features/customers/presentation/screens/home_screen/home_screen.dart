import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/user_session.dart';
import 'package:smart_reader/features/customers/presentation/blocs/customer_bloc/customer_state.dart';
import '../../../../../core/enum/customer_filter_type.dart';
import '../../../../../core/utils/app_dimens.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import '../../../../../core/utils/app_bottom_sheets.dart';
import '../../blocs/customer_bloc/customer_bloc.dart';
import '../../blocs/customer_bloc/customer_event.dart';
import '../../widgets/customer_list_view.dart';
import '../../widgets/home_filter_chip.dart';
import '../../widgets/home_header.dart';
import '../../widgets/home_search_bar.dart';
import 'home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeScreenController();
    controller.init(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetFocus();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: ()async {
          await NavigationManger.navigateTo(context, RouteNames.addCustomerScreen);
          context.read<CustomerBloc>().add(
            LoadCustomersEvent(UserSession.userId),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          "Add Customer",
          style: AppTextStyles.body.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimens.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(onSettings: () => controller.onOpenSettings(context)),
              const SizedBox(height: AppDimens.verticalSpace),

              HomeSearchBar(
                controller: controller.searchCtrl,
                focusNode: controller.searchFocus,
                onChange: (txt) => controller.onSearch(txt, context),
                onFilterTap: () => _openFilterSheet(context),
              ),
              const SizedBox(height: AppDimens.verticalSpace),

              BlocBuilder<CustomerBloc, CustomerState>(
                builder: (_, state) {
                  return HomeFilterChip(
                    filter: state.filterType,
                    visible: state.showFilterChip,
                    onClear: () {
                      controller.searchCtrl.clear();
                      context.read<CustomerBloc>().add(ResetFilterEvent());
                    },
                  );
                },
              ),
              const SizedBox(height: AppDimens.verticalSpace),
              const Expanded(child: CustomerListView()),
            ],
          ),
        ),
      ),
    );
  }


  void _openFilterSheet(BuildContext context) {
    AppBottomSheets.showScanOptions(
      context: context,
      onStreet: () {
        context.read<CustomerBloc>().add(
          ChangeFilterEvent(CustomerFilterType.street),
        );
      },
      onName: () {
        context.read<CustomerBloc>().add(
          ChangeFilterEvent(CustomerFilterType.name),
        );
      },
    );
  }

}

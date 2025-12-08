import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';

import '../../../../../core/enum/location_mode.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../blocs/customer_bloc/customer_bloc.dart';
import '../../blocs/customer_bloc/customer_state.dart';
import '../../widgets/customer_input_section.dart';
import '../../widgets/location_mode_box.dart';
import 'add_customer_screen_controller.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  late final AddCustomerScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = AddCustomerScreenController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerBloc, CustomerState>(
      listenWhen: (p, c) =>
          p.addSuccess != c.addSuccess || p.addError != c.addError,
      listener: (context, state) {
        if (state.addSuccess) {
          AppSnackBar.success(context, "Customer added successfully");
          Navigator.pop(context);
        }

        if (state.addError != null) {
          AppSnackBar.error(context, state.addError!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Customer", style: AppTextStyles.heading3),
                Text(
                  "Enter customer details",
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimens.verticalSpace),
                LocationModeBox(
                  mode: controller.mode,
                  latCtrl: controller.latCtrl,
                  lngCtrl: controller.lngCtrl,
                  onGpsTap: () => controller.getGps(context),
                  onSelectGps: () => setState(() => controller.mode = LocationMode.gps),
                  onSelectManual: () => setState(() => controller.mode = LocationMode.manual),
                ),
                const SizedBox(height: AppDimens.verticalSpaceLarge),
                Divider(color: AppColors.border),
                const SizedBox(height: AppDimens.verticalSpace),
                CustomerInputSection(
                  nameCtrl: controller.nameCtrl,
                  addressCtrl: controller.addressCtrl,
                  streetCtrl: controller.streetCtrl,
                ),

                const SizedBox(height: AppDimens.verticalSpaceLarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:() =>  state.isLoadingAdd ? null : controller.saveCustomer(context),
                    child: state.isLoadingAdd
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save Customer"),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }


}

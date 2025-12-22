import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';
import 'package:smart_reader/features/electrical_panels/presentation/blocs/panel_bloc/panel_bloc.dart';
import 'package:smart_reader/features/electrical_panels/presentation/blocs/panel_bloc/panel_bloc.dart';

import '../../../../../core/enum/location_mode.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../generated/locale_keys.g.dart';

import '../../../../electrical_panels/presentation/blocs/panel_bloc/panel_event.dart';
import '../../../../electrical_panels/presentation/blocs/panel_bloc/panel_state.dart';
import '../../blocs/user_bloc/user_bloc.dart';
import '../../blocs/user_bloc/user_state.dart';
import '../../widgets/electrical_panel_dropdown.dart';
import '../../widgets/user_input_section.dart';
import '../../widgets/location_mode_box.dart';
import 'add_user_screen_controller.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  late final AddUserScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = AddUserScreenController();

    context.read<PanelBloc>().add(LoadElectricalPanelsEvent());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listenWhen: (p, c) =>
      p.addSuccess != c.addSuccess || p.addError != c.addError,
      listener: (context, state) {
        if (state.addSuccess) {
          AppSnackBar.success(context, LocaleKeys.user_added_success.t);
          Navigator.pop(context);
        }

        if (state.addError != null) {
          AppSnackBar.error(context, state.addError!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    LocaleKeys.add_user_title.t, style: AppTextStyles.heading3),
                Text(
                  LocaleKeys.add_user_subtitle.t,
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
                  onSelectGps: () =>
                      setState(() => controller.mode = LocationMode.gps),
                  onSelectManual: () =>
                      setState(() => controller.mode = LocationMode.manual),
                ),
                const SizedBox(height: AppDimens.verticalSpaceLarge),
                Divider(color: AppColors.border),
                const SizedBox(height: AppDimens.verticalSpace),
                BlocBuilder<PanelBloc, PanelState>(
                  builder: (context, state) {
                    return UserInputSection(
                      nameCtrl: controller.nameCtrl,
                      idNumberCtrl: controller.idNumberCtrl,
                      phoneCtrl: controller.phoneCtrl,
                      addressCtrl: controller.addressCtrl,
                      streetCtrl: controller.streetCtrl,
                      dropDownMenu: ElectricalPanelDropdown(
                        panels: state.panels,
                        value: controller.selectedPanel,
                        onChanged: (panel) {
                          setState(() {
                            controller.selectedPanel = panel;
                          });
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppDimens.verticalSpaceLarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                    state.isLoadingAdd ? null : controller.saveUser(context),
                    child: state.isLoadingAdd
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(LocaleKeys.save_user.t),
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

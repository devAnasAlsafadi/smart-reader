import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/widgets/language_bottom_sheet.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/widgets/settings_about_section.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/widgets/settings_account_section.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/widgets/settings_data_management_section.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/widgets/settings_features_section.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/widgets/settings_preferences_section.dart';

import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/app_dialog.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../auth/presentation/blocs/auth_bloc/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          NavigationManger.pushNamedAndRemoveUntil(
            context,
            RouteNames.login,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocaleKeys.settings.t, style: AppTextStyles.heading2),
              Text(LocaleKeys.settings_subtitle.t,
                  style: AppTextStyles.bodySecondary),

              SizedBox(height: AppDimens.verticalSpace,),
               SettingsAccountSection(),


               SettingsFeaturesSection(),


              SettingsPreferencesSection(
                isDark: isDark,
                onChanged: (bool value) {
                  setState(() => isDark = value);
                },
                onLanguageTap: () {
                  showLanguageBottomSheet(context);
                },
              ),

              const SizedBox(height: AppDimens.verticalSpaceLarge),
               SettingsDataManagementSection(),
              const SizedBox(height: AppDimens.verticalSpace),

              _logoutButton(),

              const SizedBox(height: AppDimens.verticalSpaceLarge),

               SettingsAboutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return  ElevatedButton.icon(
      onPressed: () async {
        final confirmed = await AppDialog.showDeleteConfirm(
          context,
          title: LocaleKeys.logout.t,
          message: LocaleKeys.logout_confirm.t,
          confirmText: LocaleKeys.logout.t,
          cancelText: LocaleKeys.cancel.t,
        );

        if (confirmed == true) {
          context.read<AuthBloc>().add(LogoutEvent());
        }
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        minimumSize: Size(double.infinity, 60),
      ),
      label: Text(LocaleKeys.logout.t, style: AppTextStyles.heading3),
      icon: Icon(Icons.logout, color: AppColors.black),
    );
  }
  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const LanguageBottomSheet(),
    );
  }
}

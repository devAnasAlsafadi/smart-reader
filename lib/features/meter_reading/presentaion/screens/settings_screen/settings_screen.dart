import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:smart_reader/core/user_session.dart';
import 'package:smart_reader/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';

import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../../../core/utils/app_dialog.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../auth/data/models/user_model.dart';
import '../../widgets/build_settings_section.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state)async {
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
              Text("Settings", style: AppTextStyles.heading2),
              Text(
                "Manage your account and preferences",
                style: AppTextStyles.bodySecondary,
              ),
              SizedBox(height: AppDimens.verticalSpaceLarge),
              Text(
                'ACCOUNT',
                style: AppTextStyles.body.copyWith(color: AppColors.grey),
              ),
              SizedBox(height: AppDimens.verticalSpaceSmall),
              BuildSettingsSection(
                title: UserSession.userName.isEmpty ? "User" : UserSession.userName,
                subtitle: UserSession.currentUser?.emailHive ?? "",
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                leading: Icon(Icons.person_pin_outlined),
              ),
              SizedBox(height: AppDimens.verticalSpaceLarge),
              Text(
                'FEATURE',
                style: AppTextStyles.body.copyWith(color: AppColors.grey),
              ),
              SizedBox(height: AppDimens.verticalSpaceSmall),
              BuildSettingsSection(
                onTap: () => NavigationManger.navigateTo(context, RouteNames.guide),
                title: "How It Works",
                subtitle: "Learn About Ocr Scanning",
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.radius),
                    color: AppColors.primaryLight.withValues(alpha: .2),
                  ),
                  padding: EdgeInsets.all(AppDimens.paddingSmall),
                  child: Icon(
                    Icons.menu_book_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: AppDimens.verticalSpace),

              BuildSettingsSection(
                onTap: () => NavigationManger.navigateTo(context, RouteNames.history),
                title: "All Readings",
                subtitle: "View Complete Reading History",
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.radius),
                    color: AppColors.purple
                        .withValues(alpha: .1)
                        .withValues(alpha: .2),
                  ),
                  padding: EdgeInsets.all(AppDimens.paddingSmall),
                  child: Icon(Icons.refresh, color: AppColors.purple),
                ),
              ),
              SizedBox(height: AppDimens.verticalSpaceLarge),
              Text(
                'PREFERENCES',
                style: AppTextStyles.body.copyWith(color: AppColors.grey),
              ),
              SizedBox(height: AppDimens.verticalSpaceSmall),
              BuildSettingsSection(
                title: "Dark Mode",
                subtitle: isDark ? "Enabled" : "Disabled",
                trailing: StatefulBuilder(
                  builder: (_, setSwitchState) {
                    return Switch(
                      value: isDark,
                      activeThumbColor: AppColors.primary,
                      onChanged: (v) {
                        setSwitchState(() => isDark = v);
                      },
                    );
                  },
                ),
                leading: const Icon(
                  Icons.wb_sunny_outlined,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: AppDimens.verticalSpace),

              BuildSettingsSection(
                title: "Data Storage",
                subtitle: "Local device only",
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.radius),
                    color: AppColors.green
                        .withValues(alpha: .1)
                        .withValues(alpha: .2),
                  ),
                  child: Icon(Icons.storage, color: AppColors.green),
                  padding: EdgeInsets.all(AppDimens.paddingSmall),
                ),
              ),
              SizedBox(height: AppDimens.verticalSpaceLarge),
              Text(
                'Data Management',
                style: AppTextStyles.body.copyWith(color: AppColors.grey),
              ),
              SizedBox(height: AppDimens.verticalSpaceSmall),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppDimens.paddingLarge),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                  ),
                  child: Center(
                    child: Text(
                      "Clear All Data",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.accentRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppDimens.verticalSpaceLarge),
              ElevatedButton.icon(
                onPressed: () async {
                  final confirmed = await AppDialog.showDeleteConfirm(
                    context,
                    title: "Logout",
                    message: "Are you sure you want to log out from your account?",
                    confirmText: "Logout",
                    cancelText: "Cancel",
                  );

                  if (confirmed == true) {
                    context.read<AuthBloc>().add(LogoutEvent());
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  minimumSize: Size(double.infinity, 60),
                ),
                label: Text('Logout', style: AppTextStyles.heading3),
                icon: Icon(Icons.logout, color: AppColors.black),
              ),
              SizedBox(height: AppDimens.verticalSpaceLarge),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("About MeterScan", style: AppTextStyles.subtitle),
                    const SizedBox(height: 8),
                    Text(
                      "AI-powered electricity meter reader using on-device OCR technology. "
                      "Your data stays private and secure on your device.",
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Version 1.0.0",
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

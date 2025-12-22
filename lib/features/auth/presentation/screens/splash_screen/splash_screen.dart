import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/features/app_settings/domain/usecases/get_billing_settings_usecase.dart';
import 'package:smart_reader/features/app_settings/domain/usecases/sync_billing_settings_usecase.dart';
import 'package:smart_reader/features/auth/presentation/screens/splash_screen/splash_screen_controller.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../meter_reading/presentaion/widgets/loading_dots_widget.dart';

class SplashScreen extends StatefulWidget {

  final GetBillingSettingsUseCase getBillingSettings;
  final SyncBillingSettingsUseCase syncBillingSettings;

  const SplashScreen({
    super.key,
    required this.getBillingSettings,
    required this.syncBillingSettings,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SplashScreenController(
      getBillingSettings: widget.getBillingSettings,
      syncBillingSettings: widget.syncBillingSettings,
    );
    _controller.startApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            SizedBox(height: AppDimens.verticalSpaceLarge),
            Text(LocaleKeys.splash_title.tr(), style: AppTextStyles.heading2),
            const SizedBox(height: AppDimens.verticalSpaceSmall),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
              child: Text(
                LocaleKeys.splash_subtitle.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
            ),
            const SizedBox(height: AppDimens.verticalSpaceLarge),
            const LoadingDots(),
          ],
        ),
      ),
    );
  }

  Container _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.padding),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
      ),
      child: SvgPicture.asset(
        AppAssets.logo,
        width: AppDimens.iconLarge,
        height: AppDimens.iconLarge,
      ),
    );
  }
}

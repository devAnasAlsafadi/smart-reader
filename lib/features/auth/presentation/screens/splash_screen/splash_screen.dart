import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/features/auth/presentation/screens/splash_screen/splash_screen_controller.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../../meter_reading/presentaion/widgets/loading_dots_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late SplashScreenController _controller;

  @override
  void initState() {
    super.initState();
    if (!context.mounted) return;
    _controller = SplashScreenController();
    _controller.startApp(context);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.padding),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
              ),
              child: SvgPicture.asset(AppAssets.logo,width: AppDimens.iconLarge,
                height: AppDimens.iconLarge,),
            ),
            SizedBox(height: AppDimens.verticalSpaceLarge),
             Text(
              "MeterScan",
              style: AppTextStyles.heading2
            ),
            const SizedBox(height: AppDimens.verticalSpaceSmall),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
              child: Text(
                "Powered by AI-driven vision technology to read your electricity meter instantly and accurately.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary
              ),
            ),
            const SizedBox(height: AppDimens.verticalSpaceLarge),
            const LoadingDots(),

          ],
        ),
      ),
    );
  }
}




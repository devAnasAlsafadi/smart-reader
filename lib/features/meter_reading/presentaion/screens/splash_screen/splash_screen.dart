import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:smart_reader/core/app_assets.dart';
import 'package:smart_reader/core/app_dimens.dart';
import 'package:smart_reader/core/routes/app_router.dart';
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';

import '../../../../../core/routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();

    Future.delayed( Duration(seconds: 2),() {
      if(!mounted) return;
      NavigationManger.navigateAndReplace(context, RouteNames.home);
    },);

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


class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds:  AppDimens.animSlow),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        int activeDot = (_controller.value * 3).floor() % 3;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: AppDimens.animFast),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: activeDot == index ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}


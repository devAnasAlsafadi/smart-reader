// Flutter
import 'package:flutter/material.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';

// Widgets
import '../../widgets/key_text_item.dart';
import '../../widgets/step_card_item.dart';


class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationManger.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(  LocaleKeys.how_it_works.t, style: AppTextStyles.heading1),
            const SizedBox(height: 4),
            Text(  LocaleKeys.simple_3_steps.t, style: AppTextStyles.subtitle),
            const SizedBox(height: 24),
            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepCardItem(
                    icon: Icons.camera_alt_outlined,
                    title: LocaleKeys.step_capture.t,
                    step: LocaleKeys.step1.t,
                    color: Colors.blue.shade100.withValues(alpha: .3),
                    description: LocaleKeys.step_capture_desc.t,

                  ),
                  const SizedBox(height: 16),
                  StepCardItem(
                    icon: Icons.auto_awesome,
                    title: LocaleKeys.step_extract.t,
                    step: LocaleKeys.step2.t,
                    color: Colors.purple.shade100.withValues(alpha: .3),
                    description: LocaleKeys.step_extract_desc.t,

                  ),
                  const SizedBox(height: 16),
                  StepCardItem(
                    icon: Icons.check_circle_outline,
                    title: LocaleKeys.step_confirm.t,
                    step: LocaleKeys.step3.t,
                    color: Colors.green.shade100.withValues(alpha: .3),
                    description: LocaleKeys.step_confirm_desc.t,
                  ),
                  const SizedBox(height: 26),
                  _buildFeaturesCard(),
                  const SizedBox(height: 24),
                  _buildTipCard(),
                  const SizedBox(height: 30),
                ],
              ),
            ),),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.flash_on, color: Colors.white),
                label:  Text(LocaleKeys.get_started.t),
                onPressed: () => NavigationManger.navigateTo(context, RouteNames.camera),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      )
    );
  }


  Widget _buildFeaturesCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Row(
            children: [
              Icon(Icons.bolt, color: AppColors.primary),
              SizedBox(width: 8),
              Text(LocaleKeys.key_features.t, style: AppTextStyles.heading2),
            ],
          ),
          SizedBox(height: 14),
          KeyTextItem(LocaleKeys.feature_on_device.t),
          KeyTextItem(LocaleKeys.feature_accuracy.t),
          KeyTextItem(LocaleKeys.feature_manual_edit.t),
          KeyTextItem(LocaleKeys.feature_history.t),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          const Icon(Icons.lightbulb_outline, color: Colors.orange),
          const SizedBox(width: 12),
            Expanded(
            child: Text(
              LocaleKeys.pro_tip.t,
              style: AppTextStyles.bodySecondary,
            ),
          ),
        ],
      ),
    );
  }
}


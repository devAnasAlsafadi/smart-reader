import 'package:flutter/material.dart';
import 'package:smart_reader/core/routes/route_name.dart';

import '../../../../../core/utils/app_dimens.dart';
import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
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
            Text("How It Works", style: AppTextStyles.heading1),
            const SizedBox(height: 4),
            Text("Simple 3-step process", style: AppTextStyles.subtitle),
            const SizedBox(height: 24),
            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepCardItem(
                    icon: Icons.camera_alt_outlined,
                    title: "Capture",
                    step: "Step 1",
                    color: Colors.blue.shade100.withValues(alpha: .3),
                    description:
                    "Point your camera at the electricity meter and take a clear photo.",
                  ),
                  const SizedBox(height: 16),
                  StepCardItem(
                    icon: Icons.auto_awesome,
                    title: "Extract",
                    step: "Step 2",
                    color: Colors.purple.shade100.withValues(alpha: .3),
                    description:
                    "Our AI OCR instantly detects the numeric digits on your meter.",
                  ),
                  const SizedBox(height: 16),
                  StepCardItem(
                    icon: Icons.check_circle_outline,
                    title: "Confirm",
                    step: "Step 3",
                    color: Colors.green.shade100.withValues(alpha: .3),
                    description:
                    "Review the extracted reading, edit if needed, and save it to your history.",
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
                label: const Text("Get Started"),
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
        children: const [
          Row(
            children: [
              Icon(Icons.bolt, color: AppColors.primary),
              SizedBox(width: 8),
              Text("Key Features", style: AppTextStyles.heading2),
            ],
          ),
          SizedBox(height: 14),
          KeyTextItem("On-device OCR — your data never leaves your phone."),
          KeyTextItem("High accuracy with confidence indicators."),
          KeyTextItem("Manual editing for full control."),
          KeyTextItem("Complete reading history with timestamps."),
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
        children: const [
          Icon(Icons.lightbulb_outline, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Pro tip: Ensure good lighting and keep your phone steady for the best results.",
              style: AppTextStyles.bodySecondary,
            ),
          ),
        ],
      ),
    );
  }
}


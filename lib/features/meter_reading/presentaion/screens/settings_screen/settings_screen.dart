import 'package:flutter/material.dart';

import '../../../../../core/app_dimens.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';

class SettingsScreen extends StatelessWidget {
   SettingsScreen({super.key});

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Settings",
              style: AppTextStyles.heading2,
            ),
            Text(
              "Customize your experience",
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Dark Mode", style: AppTextStyles.body),
                        Text(
                          isDark ? "Enabled" : "Disabled",
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  StatefulBuilder(
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
                ],
              ),
            ),
            const SizedBox(height: 12),

            _buildSection(
              title: "Language",
              subtitle: "English",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              icon: Icons.language,
            ),
            const SizedBox(height: 12),

            _buildSection(
              title: "Data Storage",
              subtitle: "Local device only",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              icon: Icons.storage_outlined,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.06),
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
            const SizedBox(height: 24),
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
            )
          ],
        ),
      ),
    );
  }
  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget trailing,
    required IconData icon,
    Color iconColor = AppColors.textPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color:iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/app_dimens.dart';

class BuildSettingsSection extends StatelessWidget {
  const BuildSettingsSection({super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.leading,
    this.onTap,
    Color iconColor = AppColors.textPrimary,
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final Widget leading;
  final VoidCallback? onTap;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Container(
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
            leading,
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
      ),
    );
  }
}

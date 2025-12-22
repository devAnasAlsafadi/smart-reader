import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/app_dimens.dart';

class LocationModeButton extends StatelessWidget {
  final String label;
  final String? subLabel;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const LocationModeButton({
    super.key,
    required this.label,
    this.subLabel,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: isActive ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subLabel != null) Text(subLabel!, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

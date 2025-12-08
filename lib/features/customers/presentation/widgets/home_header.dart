import 'package:flutter/material.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/user_session.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onSettings;

  const HomeHeader({super.key, required this.onSettings});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            Text(UserSession.userName, style: AppTextStyles.heading3),
          ],
        ),
        IconButton(
          onPressed: onSettings,
          icon: const Icon(Icons.settings, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

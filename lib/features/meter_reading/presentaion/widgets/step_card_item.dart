import 'package:flutter/material.dart';

import '../../../../../core/utils/app_dimens.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';

class StepCardItem extends StatelessWidget {
  const StepCardItem({super.key,
    required this.icon,
    required this.title,
    required this.step,
    required this.description,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String step;
  final String description;
  final Color color;




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color,
                child: Icon(icon, size: 28, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(step, style: AppTextStyles.caption),
            ],
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                Text(description, style: AppTextStyles.bodySecondary),
                const SizedBox(height: 8),
              ],
            ),
          )
        ],
      ),
    );
  }
}

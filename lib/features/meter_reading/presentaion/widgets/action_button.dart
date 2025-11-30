import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return

      Expanded(child:GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 4,
          //     offset: Offset(0, 2),
          //   )
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
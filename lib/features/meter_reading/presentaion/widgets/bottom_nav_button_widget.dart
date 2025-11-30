import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_reader/core/app_dimens.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';

import '../../../../../core/app_assets.dart';
import 'package:flutter/material.dart';

class BottomNavButtonWidget extends StatelessWidget {
  const BottomNavButtonWidget({super.key,
  required this.icon,
  required this.label,
  required this.onTap,
  });

  final  IconData icon;
  final  String label;
  final  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingLarge,
            vertical: AppDimens.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.textPrimary, size: 20),
              const SizedBox(width: 6),
              Text(label, style: AppTextStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}

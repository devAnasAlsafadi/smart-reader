import 'package:flutter/material.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';

import 'app_dimens.dart';

class AppBottomSheets {
  static void showScanOptions({
    required BuildContext context,
    required VoidCallback onStreet,
    required VoidCallback onName,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLarge),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select to Filter", style: AppTextStyles.heading2),
              const SizedBox(height: AppDimens.verticalSpaceLarge),

              _optionButton(
                icon: Icons.search_off,
                text: "Search by Name",
                onTap: () {
                  Navigator.pop(context);
                  onName();
                },
              ),

              const SizedBox(height: AppDimens.verticalSpace),

              _optionButton(
                icon: Icons.streetview,
                text: "Search by Street",
                onTap: () {
                  Navigator.pop(context);
                  onStreet();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _optionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.padding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: AppColors.primary),
            const SizedBox(width: AppDimens.padding),
            Text(text, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}

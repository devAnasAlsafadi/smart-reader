import 'package:flutter/material.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';


class AppDialog {
  static Future<void> showInfo(
      BuildContext context, {
        required String title,
        required String message,
        String buttonText = "OK",
      }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text(title, style: AppTextStyles.heading2),
        content: Text(message, style: AppTextStyles.bodySecondary),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Confirmation dialog (used for delete etc.)
  static Future<bool?> showConfirm(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = "Confirm",
        String cancelText = "Cancel",
        Color confirmColor = AppColors.accentRed,
      }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text(title, style: AppTextStyles.heading2),
        content: Text(
          message,
          style: AppTextStyles.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }


  static Future<bool?> showDeleteConfirm(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = "Delete",
        String cancelText = "Cancel",
      }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warning Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.accentRed,
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Dynamic Title
              Text(
                title,
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 10),

              // Dynamic Message
              Text(
                message,
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: 25),

              // Confirm Button (Delete)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(confirmText),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    cancelText,
                    style: AppTextStyles.subtitle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}

import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';

import '../../features/meter_reading/data/repositories/meter_reading_repository_impl.dart';
import '../../generated/locale_keys.g.dart';


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
        String? confirmText,
        String? cancelText,
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
            child: Text(  cancelText ?? LocaleKeys.cancel.t,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(  confirmText ?? LocaleKeys.step_confirm.t,
            ),
          ),
        ],
      ),
    );
  }


  static Future<bool?> showDeleteConfirm(
      BuildContext context, {
        required String title,
        required String message,
        String? confirmText,
        String? cancelText,
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
                  child: Text(  confirmText ?? LocaleKeys.step_confirm.t,
                  ),
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
                    cancelText ?? LocaleKeys.cancel.t,
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


  static Future<void> showReadingResult(
      BuildContext context, {
        required ReadingCalculationResult result,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Icon
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: .15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.accentGreen,
                  size: 42,
                ),
              ),

              const SizedBox(height: 16),

              // ✅ Title
              Text(
                LocaleKeys.reading_added_successfully.t,
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Previous / New
              _valueRow(  LocaleKeys.previous_reading.t,
                  result.previousValue),
              _divider(),
              _valueRow(LocaleKeys.new_reading.t, result.newValue),

              const SizedBox(height: 14),

              // Consumption
              _highlightBox(
                label: LocaleKeys.consumption.t,
                value:
                "${result.consumption.toStringAsFixed(2)} kWh",
                color: AppColors.primary,
              ),

              const SizedBox(height: 10),

              // Cost
              _highlightBox(
                label: LocaleKeys.cost_added.t,
                value:
                "₪ ${result.cost.toStringAsFixed(2)}",
                color: AppColors.accentGreen,
                isPositive: true,
              ),

              const SizedBox(height: 12),

              Text(
                LocaleKeys.balance_added_message.t,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 18),

              // Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(LocaleKeys.got_it.t),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  static Widget _valueRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.caption),
        Text(
          value.toStringAsFixed(2),
          style: AppTextStyles.body,
        ),
      ],
    );
  }

  static Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Divider(height: 1),
    );
  }

  static Widget _highlightBox({
    required String label,
    required String value,
    required Color color,
    bool isPositive = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(color: color),
          ),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: isPositive ? AppColors.accentGreen : color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}

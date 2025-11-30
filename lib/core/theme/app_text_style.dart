import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTextStyles {
  const AppTextStyles._(); // private constructor

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // Subtitles
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Body Text
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Buttons
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

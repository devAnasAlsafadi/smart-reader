import 'package:flutter/material.dart';
import '../utils/app_dimens.dart';
import 'app_color.dart';
import 'app_text_style.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,

      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        onSurface: AppColors.background,
        error: AppColors.accentRed,
        brightness: Brightness.light,
      ),

      // -------------------------
      // App Bar Theme
      // -------------------------
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        titleTextStyle: AppTextStyles.heading2,
      ),

      // -------------------------
      // TextTheme
      // -------------------------
      textTheme: base.textTheme.copyWith(
        headlineMedium: AppTextStyles.heading1,  // 24
        titleLarge: AppTextStyles.heading2,      // 20
        titleMedium: AppTextStyles.subtitle,     // 14 semi
        bodyMedium: AppTextStyles.body,          // 14
        bodySmall: AppTextStyles.caption,        // 12
        labelLarge: AppTextStyles.button,        // buttons
      ),

      // -------------------------
      // Elevated Buttons
      // -------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius),
          ),
          minimumSize: Size.fromHeight(AppDimens.buttonHeight),
        ),
      ),

      // -------------------------
      // Card Theme
      // -------------------------
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        ),
        elevation: 2,
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimens.padding,
          vertical: 8,
        ),
      ),

      // -------------------------
      // Input Decoration (TextField)
      // -------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

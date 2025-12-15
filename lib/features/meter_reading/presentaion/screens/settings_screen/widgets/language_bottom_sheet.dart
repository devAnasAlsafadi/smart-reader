import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';

import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/utils/app_dimens.dart';
import '../../../../../../generated/locale_keys.g.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLang = context.locale.languageCode;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.select_language.t,
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 4),
          Text(
            LocaleKeys.language_change_immediately.t,
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 20),

          _languageTile(
            context,
            code: 'en',
            title: 'English',
            subtitle: 'English',
            flag: 'US',
            isSelected: currentLang == 'en',
          ),

          const SizedBox(height: 12),

          _languageTile(
            context,
            code: 'ar',
            title: 'العربية',
            subtitle: 'Arabic',
            flag: 'SA',
            isSelected: currentLang == 'ar',
          ),
        ],
      ),
    );
  }

  Widget _languageTile(
      BuildContext context, {
        required String code,
        required String title,
        required String subtitle,
        required String flag,
        required bool isSelected,
      }) {
    return InkWell(
      onTap: () {
        context.setLocale(Locale(code));
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withValues(alpha: .08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}

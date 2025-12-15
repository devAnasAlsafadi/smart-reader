import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';

import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../generated/locale_keys.g.dart';

class ResultHeader extends StatelessWidget {
  const ResultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.reading_extracted.t,
          style: AppTextStyles.heading1,
        ),
        Text(
          LocaleKeys.ai_detected_value.t,
          style: AppTextStyles.bodySecondary,
        ),
      ],
    );
  }
}

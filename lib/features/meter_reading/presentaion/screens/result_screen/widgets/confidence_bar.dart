import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/utils/app_dimens.dart';
import '../../../../../../generated/locale_keys.g.dart';

class ConfidenceBar extends StatelessWidget {
  const ConfidenceBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(alignment: Alignment.center,child: Text(LocaleKeys.confidence.t, style: AppTextStyles.body)),
          SizedBox(height: 5,),
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.accentGreen),
              const SizedBox(width: 8),
              Text(LocaleKeys.confidence.t, style: AppTextStyles.subtitle),
              const Spacer(),
              Text(
                "96%",
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.96,
              minHeight: 8,
              color: AppColors.accentGreen,
              backgroundColor: AppColors.border,
            ),
          ),
        ],
      ),
    );
  }
}

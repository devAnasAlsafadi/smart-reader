import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/utils/app_dimens.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.title});
   final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.verticalSpaceSmall),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.body.copyWith(color: AppColors.grey),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';

import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/utils/app_dimens.dart';
import '../../../../../../generated/locale_keys.g.dart';

class ReadingValueCard extends StatelessWidget {
  const ReadingValueCard({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:  EdgeInsetsDirectional.symmetric(vertical:40,horizontal: AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Text(LocaleKeys.meter_reading.t, style: AppTextStyles.heading2),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: AppTextStyles.heading1.copyWith(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

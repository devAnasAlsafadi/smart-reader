import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/widgets/title_section.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

class SettingsDataManagementSection extends StatelessWidget {
   SettingsDataManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(title: LocaleKeys.data_management.t),
        SizedBox(height: AppDimens.verticalSpace,),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.paddingLarge),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
            ),
            child: Center(
              child: Text(
                LocaleKeys.clear_all_data.t,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.accentRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

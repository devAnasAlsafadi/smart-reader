import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/widgets/title_section.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

import '../../../widgets/build_settings_section.dart';

class SettingsFeaturesSection extends StatelessWidget {
   SettingsFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(title:LocaleKeys.features.t,),
        BuildSettingsSection(
          onTap: () =>
              NavigationManger.navigateTo(context, RouteNames.guide),
          title: LocaleKeys.how_it_works.t,
          subtitle: LocaleKeys.learn_ocr.t,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          leading: _icon(Icons.menu_book_outlined, AppColors.primary),
        ),
        const SizedBox(height: AppDimens.verticalSpace),
        BuildSettingsSection(
          onTap: () =>
              NavigationManger.navigateTo(context, RouteNames.history),
          title: LocaleKeys.all_readings.t,
          subtitle: LocaleKeys.reading_history.t,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          leading: _icon(Icons.refresh, AppColors.purple),
        ),
        const SizedBox(height: AppDimens.verticalSpaceLarge),
      ],
    );
  }

  Widget _icon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingSmall),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(AppDimens.radius),
      ),
      child: Icon(icon, color: color),
    );
  }
}

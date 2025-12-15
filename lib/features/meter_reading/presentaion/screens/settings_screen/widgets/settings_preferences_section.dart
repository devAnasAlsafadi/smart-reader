import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/widgets/title_section.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

import '../../../widgets/build_settings_section.dart';

class SettingsPreferencesSection extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;
  final VoidCallback onLanguageTap;


  const SettingsPreferencesSection({
    super.key,
    required this.isDark,
    required this.onChanged,
    required this.onLanguageTap,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(title:LocaleKeys.preferences.t,),
        BuildSettingsSection(
          title: LocaleKeys.dark_mode.t,
          subtitle: isDark
              ? LocaleKeys.enabled.t
              : LocaleKeys.disabled.t,
          trailing: Switch(value: isDark, onChanged: onChanged),
          leading: const Icon(
            Icons.wb_sunny_outlined,
            color: Colors.orange,
          ),
        ),
         SizedBox(height: AppDimens.verticalSpace,),
        BuildSettingsSection(
          title: LocaleKeys.data_storage.t,
          subtitle:LocaleKeys.local_device_only.t,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          leading: const Icon(
            Icons.storage,
            color: Colors.greenAccent,
          ),
        ),
        SizedBox(height: AppDimens.verticalSpace,),
        BuildSettingsSection(
          title: LocaleKeys.language.t,
          subtitle: context.locale.languageCode == 'ar'
              ? LocaleKeys.arabic.t
              : LocaleKeys.english.t,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          leading: const Icon(
            Icons.language,
            color: Colors.blue,
          ),
          onTap: onLanguageTap,
        ),
      ],
    );
  }
}

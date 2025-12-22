import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/user_session.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/settings_screen/widgets/title_section.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

import '../../../widgets/build_settings_section.dart';


class SettingsAccountSection extends StatelessWidget {
   SettingsAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(title:LocaleKeys.account.t,),
        BuildSettingsSection(
          title: EmployeeSession.employeeName.isEmpty
              ? LocaleKeys.account.t
              : EmployeeSession.employeeName,
          subtitle: EmployeeSession.currentEmployee?.emailHive ?? '',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          leading: const Icon(Icons.person_pin_outlined),
        ),
        const SizedBox(height: AppDimens.verticalSpaceLarge),
      ],
    );
  }


}

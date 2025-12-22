// Flutter
import 'package:flutter/material.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';

// Shared Widgets
import 'package:smart_reader/features/auth/presentation/widgets/my_text_field.dart';


class UserInputSection extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController idNumberCtrl;
  final TextEditingController phoneCtrl;

  final Widget dropDownMenu;

  final TextEditingController addressCtrl;
  final TextEditingController streetCtrl;


  const UserInputSection({
    super.key,
    required this.nameCtrl,
    required this.idNumberCtrl,
    required this.phoneCtrl,
    required this.dropDownMenu,
    required this.addressCtrl,
    required this.streetCtrl,
  });



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.user_information.t,
          style: AppTextStyles.subtitle,
        ),
        const SizedBox(height: AppDimens.verticalSpace),

        // User Name
        Text(
          "${LocaleKeys.user_name.t} *",
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 5),
        MyTextField(
          controller: nameCtrl,
          hintText: LocaleKeys.user_name_hint.t,
          keyboardType: TextInputType.text,
          obscureText: false,
        ),

        const SizedBox(height: AppDimens.verticalSpace),


        // ID Number
        Text("${LocaleKeys.id_number.t} *", style: AppTextStyles.body),
        const SizedBox(height: 5),
        MyTextField(
          controller: idNumberCtrl,
          hintText: LocaleKeys.id_number_hint.t,
          keyboardType: TextInputType.number,
          obscureText: false,
        ),

        const SizedBox(height: AppDimens.verticalSpace),

        // Phone
        Text("${LocaleKeys.phone_number.t} *", style: AppTextStyles.body),
        const SizedBox(height: 5),
        MyTextField(
          controller: phoneCtrl,
          hintText: LocaleKeys.phone_number_hint.t,
          keyboardType: TextInputType.phone,
          obscureText: false,
        ),

        const SizedBox(height: AppDimens.verticalSpace),

        // Electrical Panel (Dropdown)
        Text("${LocaleKeys.electrical_panel.t} *", style: AppTextStyles.body),
        const SizedBox(height: 5),
        dropDownMenu,

        const SizedBox(height: AppDimens.verticalSpace),


        // Address
        Text(
          "${LocaleKeys.user_address.t} *",
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 5),
        MyTextField(
          controller: addressCtrl,
          hintText: LocaleKeys.user_address_hint.t,
          keyboardType: TextInputType.text,
          obscureText: false,
        ),
        const SizedBox(height: AppDimens.verticalSpace),



        // Street
        Text(
          "${LocaleKeys.user_street.t} *",
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 5),
        MyTextField(
          controller: streetCtrl,
          hintText: LocaleKeys.user_street_hint.t,
          keyboardType: TextInputType.text,
          obscureText: false,
        ),
      ],
    );
  }
}

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


class CustomerInputSection extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController streetCtrl;

  const CustomerInputSection({
    super.key,
    required this.nameCtrl,
    required this.addressCtrl,
    required this.streetCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.customer_information.t,
          style: AppTextStyles.subtitle,
        ),
        const SizedBox(height: AppDimens.verticalSpace),

        Text(
          "${LocaleKeys.customer_name.t} *",
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 5),
        MyTextField(
          controller: nameCtrl,
          hintText: LocaleKeys.customer_name_hint.t,
          keyboardType: TextInputType.text,
          obscureText: false,
        ),

        const SizedBox(height: AppDimens.verticalSpace),

        Text(
          "${LocaleKeys.customer_address.t} *",
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 5),
        MyTextField(
          controller: addressCtrl,
          hintText: LocaleKeys.customer_address_hint.t,
          keyboardType: TextInputType.text,
          obscureText: false,
        ),

        const SizedBox(height: AppDimens.verticalSpace),

        Text(
          "${LocaleKeys.customer_street.t} *",
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 5),
        MyTextField(
          controller: streetCtrl,
          hintText: LocaleKeys.customer_street_hint.t,
          keyboardType: TextInputType.text,
          obscureText: false,
        ),
      ],
    );
  }
}

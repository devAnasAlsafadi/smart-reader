import 'package:flutter/material.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../auth/presentation/widgets/my_text_field.dart';

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
        Text("Customer Information", style: AppTextStyles.subtitle),
        const SizedBox(height: AppDimens.verticalSpace),

        Text("Customer Name *", style: AppTextStyles.body),
        const SizedBox(height: 5),
        MyTextField(
          controller: nameCtrl,
          hintText: "John Doe",
          keyboardType: TextInputType.text,
          obscureText: false,
        ),

        const SizedBox(height: AppDimens.verticalSpace),

        Text("Address (Area/City) *", style: AppTextStyles.body),
        const SizedBox(height: 5),
        MyTextField(
          controller: addressCtrl,
          hintText: "New York, USA",
          keyboardType: TextInputType.text,
          obscureText: false,
        ),

        const SizedBox(height: AppDimens.verticalSpace),

        Text("Street *", style: AppTextStyles.body),
        const SizedBox(height: 5),
        MyTextField(
          controller: streetCtrl,
          hintText: "Main Street",
          keyboardType: TextInputType.text,
          obscureText: false,
        ),
      ],
    );
  }
}

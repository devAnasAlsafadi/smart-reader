import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../generated/locale_keys.g.dart';

class ConfirmReadingButton extends StatelessWidget {
  const ConfirmReadingButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGreen,
        ),
        child: Text(LocaleKeys.confirm_reading.t),
      ),
    );
  }
}

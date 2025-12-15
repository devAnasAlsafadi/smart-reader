// Flutter
import 'package:flutter/material.dart';



// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/edit_reading_screen/widgets/confirm_reading_button.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/edit_reading_screen/widgets/reading_input_card.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';



class EditReadingScreen extends StatefulWidget {
  const EditReadingScreen({
    super.key,
    required this.initialReading,
  });

  final double initialReading;

  @override
  State<EditReadingScreen> createState() => _EditReadingScreenState();
}

class _EditReadingScreenState extends State<EditReadingScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.initialReading.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() async {
    final value = double.tryParse(_controller.text.trim());

    if (value == null) {
      AppSnackBar.error(
        context,
        LocaleKeys.invalid_numeric_value.t,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 200));
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationManger.pop(context),
        ),
        title: Text(LocaleKeys.edit_reading.t),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.enter_correct_reading.t,
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: 40),
            ReadingInputCard(controller: _controller),
            const SizedBox(height: 40),
            ConfirmReadingButton(onPressed: _onConfirm),
          ],
        ),
      ),
    );
  }
}

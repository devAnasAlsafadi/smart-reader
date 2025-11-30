import 'package:flutter/material.dart';

import '../../../../../core/app_dimens.dart';
import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';

class EditReadingScreen extends StatefulWidget {
  const EditReadingScreen({super.key,required this.initialReading,
  });
  final String initialReading;

  @override
  State<EditReadingScreen> createState() => _EditReadingScreenState();
}

class _EditReadingScreenState extends State<EditReadingScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialReading);
    super.initState();
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
        title: const Text("Edit Reading"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingLarge), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter the correct meter reading",
                style: AppTextStyles.subtitle),
            const SizedBox(height: 50),
            _buildReadingCard(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: ()async {
                  final value = _controller.text.trim();
                  if (value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid numeric value"),
                      ),
                    );
                    return;
                  }
                  FocusScope.of(context).unfocus();
                  await Future.delayed(const Duration(milliseconds: 150));
                  Navigator.pop(context, value);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGreen,
                ),
                child: const Text("Confirm Reading"),
              ),
            ),
          ],
        ),),
      ),
    );
  }

  Widget _buildReadingCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Meter Reading (kWh)", style: AppTextStyles.subtitle),
          const SizedBox(height: 12),

          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            style: AppTextStyles.heading1,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radius),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimens.radius),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline,
                    color: AppColors.primary, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Tip: Only enter numeric digits from your meter display",
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

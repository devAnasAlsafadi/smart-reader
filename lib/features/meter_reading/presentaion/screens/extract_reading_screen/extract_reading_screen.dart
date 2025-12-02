import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/features/meter_reading/presentaion/widgets/reading_option_list.dart';
import '../../../../../core/app_dimens.dart';

import '../../../../../core/routes/route_name.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../blocs/meter_reading/meter_reading_bloc.dart';

class ExtractReadingScreen extends StatefulWidget {
  const ExtractReadingScreen({
    super.key,
    required this.readings,
    required this.rawText,
    required this.imagePath,
  });
  final List<String> readings;
  final String rawText;
  final String imagePath;

  @override
  State<ExtractReadingScreen> createState() => _ExtractReadingScreenState();
}

class _ExtractReadingScreenState extends State<ExtractReadingScreen> {
  String? selectedReading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Reading Extracted"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationManger.pop(context),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Column(
              children: [
                SizedBox(height: 12),
                Icon(
                  Icons.auto_awesome,
                  size: 48,
                  color: AppColors.primaryLight,
                ),
                SizedBox(height: 8),
                Text(
                  "AI detected multiple possible readings.\nPlease select the correct one.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radius),
              border: Border.all(
                color: AppColors.border,
                width: 1.5,
              ),
            ),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radius),
                side: BorderSide(color: AppColors.grey,width: 2),
              ),
              title: const Text("Raw OCR Text", style: AppTextStyles.body),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.rawText, style: AppTextStyles.body),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Text("Detected Readings", style: AppTextStyles.heading2),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: widget.readings.length,
              itemBuilder: (context, index) {
                final reading = widget.readings[index];
                final isSelected = reading == selectedReading;
                return ReadingOptionTile(reading: reading, isSelected: isSelected, onTap: () {
                  setState(() {
                    selectedReading = reading;
                  });
                },);
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: selectedReading == null
                  ? null
                  : () {
                      NavigationManger.navigateTo(context, RouteNames.result,arguments: {
                        'reading':widget.rawText,
                        'imagePath':widget.imagePath
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
              ),
              child: const Text("Confirm Reading"),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => NavigationManger.pop(context),
              child: const Text(
                "Try Again",
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

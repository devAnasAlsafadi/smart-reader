// Flutter
import 'package:flutter/material.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';

// Features – Meter Reading
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';
import 'package:smart_reader/features/meter_reading/presentaion/widgets/reading_option_list.dart';


class ExtractReadingScreen extends StatefulWidget {
  const ExtractReadingScreen({
    super.key,
    required this.readings,
    required this.rawText,
    required this.entity,
  });
  final List<String> readings;
  final MeterReadingEntity entity;
  final String rawText;

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
        title: Text(LocaleKeys.reading_extracted.t),
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
           Center(
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Icon(
                  Icons.auto_awesome,
                  size: 48,
                  color: AppColors.primaryLight,
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.ai_detected_multiple.t,
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
              title: Text(
                LocaleKeys.raw_ocr_text.t,
                style: AppTextStyles.body,
              ),              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.rawText, style: AppTextStyles.body),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
           Text(  LocaleKeys.detected_readings.t, style: AppTextStyles.heading2),
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
                final updated = widget.entity.copyWithNewData(
                  meterValue: double.tryParse(selectedReading!),
                );
                      NavigationManger.navigateTo(context, RouteNames.result,arguments:
                      updated);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
              ),
              child: Text(LocaleKeys.confirm_reading.t),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => NavigationManger.pop(context),
              child:  Text(
                LocaleKeys.try_again.t,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

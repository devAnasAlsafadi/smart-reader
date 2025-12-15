import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/meter_reading_entity.dart';

class HistoryCard extends StatelessWidget {
  final MeterReadingEntity reading;
  final VoidCallback onDelete;

  const HistoryCard({
    super.key,
    required this.reading,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("dd/MM/yyyy  •  hh:mm a");

    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: reading.imagePath.isNotEmpty
                ? Image.file(
              File(reading.imagePath),
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            )
                : Container(
              width: 55,
              height: 55,
              color: AppColors.primaryLight.withValues(alpha: .2),
              child: const Icon(Icons.bolt, color: AppColors.primary),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${reading.meterValue} kWh",
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(reading.timestamp),
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 4),
                Text(
                  "⚡ 95% confidence",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accentRed,
                  ),
                ),
              ],
            ),
          ),

          // --- DELETE BUTTON ---
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

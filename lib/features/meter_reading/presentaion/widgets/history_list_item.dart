import 'package:flutter/material.dart';
import '../../../../../core/utils/reading_utils.dart';
import '../../../../../core/utils/app_date_utils.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../../domain/entities/meter_reading_entity.dart';

class HistoryListItem extends StatelessWidget {
  final UserEntity user;
  final MeterReadingEntity reading;

  const HistoryListItem({
    super.key,
    required this.user,
    required this.reading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user.name, style: AppTextStyles.heading3),
            ],
          ),

          const SizedBox(height: 6),

          Text(user.street, style: AppTextStyles.caption),
          const SizedBox(height: 10),

          Text(
            "Reading: ${ReadingUtils.formatMeterValue(reading.meterValue)}",
            style: AppTextStyles.body,
          ),

          const SizedBox(height: 4),

          Text(
            AppDateUtils.formatDateTime(context,reading.timestamp),
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

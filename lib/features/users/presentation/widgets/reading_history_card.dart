// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_date_utils.dart';
import 'package:smart_reader/core/utils/app_dialog.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import 'package:smart_reader/core/utils/reading_utils.dart';

// Features – Meter Reading
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/meter_reading/meter_reading_event.dart';

// Features – Payments
import 'package:smart_reader/features/payments/presentaion/blocs/billing_bloc/billing_bloc.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/billing_bloc/billing_event.dart';


class ReadingHistoryCard extends StatelessWidget {
  final MeterReadingEntity reading;
  final String userId;

  const ReadingHistoryCard({super.key, required this.reading,required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.padding),
      padding: const EdgeInsets.all(AppDimens.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ReadingUtils.formatMeterValue(reading.meterValue),
                style: AppTextStyles.heading3,
              ),

              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () => _onDeletePressed(context),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Timestamp
          Text(
            AppDateUtils.formatDateTime(context,reading.timestamp),
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final confirmed = await AppDialog.showDeleteConfirm(
      context,
      title:LocaleKeys.delete_reading_title.t,
      message: LocaleKeys.delete_reading_message.t,
      confirmText: LocaleKeys.delete.t,
      cancelText:  LocaleKeys.cancel.t,
    );

    if (confirmed == true) {
      context.read<MeterReadingBloc>().add(DeleteReadingEvent(reading.id));
    }
  }
}

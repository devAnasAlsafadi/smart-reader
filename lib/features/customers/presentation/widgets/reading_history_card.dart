import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/utils/reading_utils.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/billing_bloc/billing_bloc.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/billing_bloc/billing_event.dart';

import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../../../core/utils/app_dimens.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../meter_reading/domain/entities/meter_reading_entity.dart';
import '../../../meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';
import '../../../meter_reading/presentaion/blocs/meter_reading/meter_reading_event.dart';

class ReadingHistoryCard extends StatelessWidget {
  final MeterReadingEntity reading;
  final String customerId;

  const ReadingHistoryCard({super.key, required this.reading,required this.customerId});

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
          // ===== Header + Delete button =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ReadingUtils.formatKwh(reading.reading),
                style: AppTextStyles.heading3,
              ),

              // Delete Button
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
            AppDateUtils.formatDateTime(reading.timestamp),
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final confirmed = await AppDialog.showDeleteConfirm(
      context,
      title: "Delete Reading",
      message: "This action will permanently remove this reading.",
      confirmText: "Delete",
      cancelText: "Cancel",
    );

    if (confirmed == true) {
      context.read<MeterReadingBloc>().add(DeleteReadingEvent(reading.id));
      context.read<BillingBloc>().add(LoadBillingEvent(customerId));

    }
  }
}

import 'package:flutter/material.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import 'package:smart_reader/features/customers/presentation/widgets/reading_history_card.dart';

import '../../../../core/utils/app_date_utils.dart';
import '../../../payments/data/services/monthly_statement.dart';
import 'payment_item.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';

class MonthlyCard extends StatelessWidget {
  final MonthlyStatement month;
  final String customerId;

  const MonthlyCard({super.key, required this.month,required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Card(

      margin: const EdgeInsets.only(bottom: 16),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

        child: ExpansionTile(

          initiallyExpanded: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppDateUtils.monthName(month.month)} ${month.year}",
                style: AppTextStyles.heading2.copyWith(fontSize: 14),
              ),
              SizedBox(height: AppDimens.verticalSpaceSmall,)
            ],
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cost: ₪${month.monthlyReadingsCost.toStringAsFixed(2)}   "
                    "Paid: ₪${month.monthlyPayments.toStringAsFixed(2)}",
                style: AppTextStyles.heading2.copyWith(fontSize: 12,color: AppColors.grey),
              ),
              SizedBox(height: AppDimens.verticalSpace,),
              Text("Balance: ₪${month.monthlyBalance.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: month.monthlyBalance > 0 ? Colors.red : Colors.green)
              ),
            ],
          ),

          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text("⚡ Readings (${month.readings.length})",
                      style: AppTextStyles.subtitle),
                  Divider(color: AppColors.grey.withValues(alpha: .3),),
                  const SizedBox(height: 8),

                  ...month.readings.map((r) => ReadingHistoryCard(reading: r, customerId: customerId,)),

                  const SizedBox(height: 12),
                  Text("\$ Payments (${month.payments.length})",
                      style: AppTextStyles.subtitle),
                  Divider(color: AppColors.grey.withValues(alpha: .3),),
                  const SizedBox(height: 8),
                  ...month.payments.map((p) => PaymentItem(payment: p,customerId: customerId,)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}

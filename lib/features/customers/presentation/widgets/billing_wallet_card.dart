import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import '../../../payments/data/services/billing_summary.dart';

class BillingWalletCard extends StatelessWidget {
  final BillingSummary summary;

  const BillingWalletCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: .4),
                  borderRadius: BorderRadius.circular(AppDimens.radius)
                ),
                padding: EdgeInsets.all(AppDimens.paddingSmall),
                  child: Icon(Icons.wallet,color: AppColors.white,)),
              SizedBox(width: 5,),
              Text("Billing Wallet", style: AppTextStyles.heading3.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _item("Total Cost", summary.totalReadingsCost)),
              SizedBox(width: 7,),
              Expanded(child: _item("Total Paid", summary.totalPayments)),
              SizedBox(width: 7,),
              Expanded(child: _item("Balance", summary.balance)),
            ],
          ),

          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: EdgeInsets.all(AppDimens.padding),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(AppDimens.radius),
              ),
              child: Text(
                "Customer owes ₪${summary.balance.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _item(String title, double value) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(AppDimens.radius),
      ),
      padding: EdgeInsets.all(AppDimens.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
          const SizedBox(height: 4),
          Align(
             alignment: Alignment.center,
            child: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              "₪ ${value.toStringAsFixed(3)}",
              style: AppTextStyles.bodySecondary.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Flutter
import 'package:flutter/material.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';

// Features – Payments
import 'package:smart_reader/features/payments/data/services/billing_summary.dart';

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
              Text(LocaleKeys.billing_wallet.t, style: AppTextStyles.heading3.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _item(LocaleKeys.total_cost.t, summary.totalReadingsCost)),
              SizedBox(width: 7,),
              Expanded(child: _item(LocaleKeys.total_paid.t, summary.totalPayments)),
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
              child: Row(
                children: [
                  Text(
                    "${LocaleKeys.customer_owes.t} : ",
                    style: AppTextStyles.heading3.copyWith(color: AppColors.white),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(AppDimens.radius)
                      ),
                      child: Text(
                        "  ₪ ${summary.balance.toStringAsFixed(2)}",
                        style: AppTextStyles.heading3.copyWith(color:summary.balance > 0  ? AppColors.red : AppColors.green  ),
                      ),
                    ),
                  ),
                ],
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: AppTextStyles.body.copyWith(color: Colors.white70)),
          const SizedBox(height: 4),
          Align(
             alignment: Alignment.center,
            child: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              "₪ ${value.toStringAsFixed(1)}",
              style: AppTextStyles.heading3.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

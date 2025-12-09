import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/payment_bloc/payment_bloc.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/payment_bloc/payment_event.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../payments/domain/entities/payment_entity.dart';
import '../../../payments/presentaion/blocs/billing_bloc/billing_bloc.dart';
import '../../../payments/presentaion/blocs/billing_bloc/billing_event.dart';

class PaymentItem extends StatelessWidget {
  final PaymentEntity payment;
  final String customerId;

  const PaymentItem({super.key, required this.payment, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ]
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "₪ ${payment.amount}",style:AppTextStyles.heading3.copyWith(color: AppColors.green),
                ),
              ),
              IconButton(
                icon:  Icon(Icons.delete_sweep_outlined, color: AppColors.grey,),
                onPressed: () {
                  _onDeletePressed(context);
                },
              )
            ],
          ),
          SizedBox(height: 5,),
          Text(
            "${payment.timestamp.day}/${payment.timestamp.month}/${payment.timestamp.year}",
            style: AppTextStyles.body.copyWith(color: AppColors.grey),
          ),
          Text(
            payment.note ?? "",
            style: AppTextStyles.body.copyWith(color: AppColors.grey),
          ),

        ],
      ),
    );
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final confirmed = await AppDialog.showDeleteConfirm(
      context,
      title: "Delete Payment",
      message: "This action will permanently remove this payment.",
      confirmText: "Delete",
      cancelText: "Cancel",
    );

    if (confirmed == true) {
      context.read<PaymentBloc>().add(DeletePaymentEvent(payment.id));
      context.read<BillingBloc>().add(LoadBillingEvent(customerId));

    }
  }
}

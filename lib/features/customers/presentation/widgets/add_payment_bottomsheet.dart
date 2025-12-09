import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';
import 'package:smart_reader/features/auth/presentation/widgets/my_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../../../payments/presentaion/blocs/payment_bloc/payment_bloc.dart';
import '../../../payments/presentaion/blocs/payment_bloc/payment_event.dart';
import '../../../payments/presentaion/blocs/billing_bloc/billing_bloc.dart';
import '../../../payments/presentaion/blocs/billing_bloc/billing_event.dart';
import '../../../payments/domain/entities/payment_entity.dart';

void showAddPaymentSheet(BuildContext context, {required String customerId}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _AddPaymentSheet(customerId: customerId);
    },
  );
}

class _AddPaymentSheet extends StatefulWidget {
  final String customerId;
  const _AddPaymentSheet({required this.customerId});

  @override
  State<_AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<_AddPaymentSheet> {
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.40,
      maxChildSize: 0.90,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.attach_money, color: AppColors.accentGreen),
                        SizedBox(width: 8),
                        Text("Add Payment",
                            style: AppTextStyles.heading3),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // --- Amount Field ---
                Text("Payment Amount *", style: AppTextStyles.subtitle),
                const SizedBox(height: 6),
                MyTextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                   hintText: "0.00",
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                // --- Note Field ---
                Text("Note (Optional)", style: AppTextStyles.subtitle),
                const SizedBox(height: 6),
                MyTextField(
                  controller: noteCtrl,
                  obscureText: false,
                  hintText: "e.g., Monthly payment", keyboardType: TextInputType.text,


                ),

                const SizedBox(height: 10),
                const Text(
                  "Payment will be recorded with today's date & time.",
                  style: AppTextStyles.caption,
                ),

                const SizedBox(height: 25),

                // --- Buttons ---
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child:  Text("Cancel",style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w500),),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGreen,
                        ),
                        onPressed: isLoading ? null : () async {
                          final amount = double.tryParse(amountCtrl.text);
                          if (amount == null || amount <= 0) {
                            Fluttertoast.showToast(
                              msg: "Invalid amount",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16,
                            );
                            return;
                          }

                          setState(() => isLoading = true);
                          final idv4 =  Uuid().v4();
                          final payment = PaymentEntity(
                            id: idv4,
                            customerId: widget.customerId,
                            amount: amount,
                            note: noteCtrl.text,
                            timestamp: DateTime.now(),
                            synced: false,
                            isDeleted: false,
                          );

                          context.read<PaymentBloc>().add(AddPaymentEvent(payment));

                          // إعادة الحسابات
                          context.read<BillingBloc>().add(
                            LoadBillingEvent(widget.customerId),
                          );

                          setState(() => isLoading = false);
                          Navigator.pop(context);

                          AppSnackBar.success(context, "Payment added");
                        },
                        child: const Text("Add Payment"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Third-party
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';

// Shared Widgets
import 'package:smart_reader/features/auth/presentation/widgets/my_text_field.dart';

// Features – Payments
import 'package:smart_reader/features/payments/domain/entities/payment_entity.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/payment_bloc/payment_bloc.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/payment_bloc/payment_event.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/billing_bloc/billing_bloc.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/billing_bloc/billing_event.dart';

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
  void dispose() {
    amountCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

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
                      children:  [
                        Icon(Icons.attach_money, color: AppColors.accentGreen),
                        SizedBox(width: 8),
                        Text(LocaleKeys.add_payment.t,
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
                Text("${LocaleKeys.payment_amount.t} *", style: AppTextStyles.subtitle),
                const SizedBox(height: 6),
                MyTextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                   hintText: LocaleKeys.payment_amount_hint.t,
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                // --- Note Field ---
                Text(LocaleKeys.payment_note.t, style: AppTextStyles.subtitle),
                const SizedBox(height: 6),
                MyTextField(
                  controller: noteCtrl,
                  obscureText: false,
                  hintText: LocaleKeys.payment_note_hint.t, keyboardType: TextInputType.text,


                ),

                const SizedBox(height: 10),
                 Text(
                  LocaleKeys.payment_info.t,
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
                        child:  Text(LocaleKeys.cancel.t,style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w500),),
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
                              msg: LocaleKeys.invalid_amount.t,
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

                          AppSnackBar.success(context, LocaleKeys.payment_added_success.t,);
                        },
                        child:  Text(LocaleKeys.add_payment.t),
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

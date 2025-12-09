import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/payment_bloc/payment_state.dart';

import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../../meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';
import '../../../../meter_reading/presentaion/blocs/meter_reading/meter_reading_state.dart';
import '../../../../payments/presentaion/blocs/billing_bloc/billing_bloc.dart';
import '../../../../payments/presentaion/blocs/billing_bloc/billing_event.dart';
import '../../../../payments/presentaion/blocs/billing_bloc/billing_state.dart';
import '../../../../payments/presentaion/blocs/payment_bloc/payment_bloc.dart';
import '../../../domain/entities/customer_entity.dart';
import '../../widgets/add_payment_bottomsheet.dart';
import '../../widgets/billing_wallet_card.dart';
import '../../widgets/monthly_card.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key, required this.customer});

  final CustomerEntity customer;

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BillingBloc>().add(LoadBillingEvent(widget.customer.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MeterReadingBloc, MeterReadingState>(
            listenWhen: (prev, curr) =>
            curr is ReadingsLoadedState || curr is ReadingDeletedState,
            listener: (context, state) {
              context.read<BillingBloc>().add(
                LoadBillingEvent(widget.customer.id),
              );
              if(state is ReadingDeletedState){
               AppSnackBar.success(context,"Reading deleted successfully");
              }
            },

          ),
          BlocListener<PaymentBloc, PaymentState>(
            listenWhen: (previous, current) =>
            previous.deleteSuccess != current.deleteSuccess,
            listener: (context, state) {
              if (state.deleteSuccess) {
                context.read<BillingBloc>().add(
                  LoadBillingEvent(widget.customer.id),
                );
                AppSnackBar.success(context, "Payment deleted successfully");
              }
            },

          ),

        ], child: BlocBuilder<BillingBloc, BillingState>(builder:
          (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(child: Text("Error: ${state.error}"));
        }
        if (state.summary == null) {
          return const Center(child: Text("No billing data available"));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.customer.name,
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16,
                      color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    widget.customer.street,
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              BillingWalletCard(summary: state.summary!),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.bolt),
                      label: const Text("Add Reading"),
                      onPressed: () async {
                        await NavigationManger.navigateTo(
                          context,
                          RouteNames.camera,
                          arguments: widget.customer.id,
                        );
                        context.read<BillingBloc>().add(
                          LoadBillingEvent(widget.customer.id),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.attach_money),
                      label: const Text("Add Payment"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGreen,
                      ),
                      onPressed: () {
                        showAddPaymentSheet(
                          context,
                          customerId: widget.customer.id,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text("Monthly Breakdown", style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.monthly.length,
                itemBuilder: (context, index) {
                  return MonthlyCard(month: state.monthly[index],
                    customerId: widget.customer.id,);
                },
              ),


            ],
          ),
        );
      },),

      ),
    );
  }
}

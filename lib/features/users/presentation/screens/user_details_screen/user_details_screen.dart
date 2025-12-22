// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Localization
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';

// Features – Meter Reading
import '../../../../meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';
import '../../../../meter_reading/presentaion/blocs/meter_reading/meter_reading_state.dart';


// Features – Payments
import 'package:smart_reader/features/payments/presentaion/blocs/billing_bloc/billing_bloc.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/billing_bloc/billing_event.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/billing_bloc/billing_state.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/payment_bloc/payment_bloc.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/payment_bloc/payment_state.dart';

import '../../../domain/entities/user_entity.dart';
import '../../widgets/add_payment_bottomsheet.dart';
import '../../widgets/billing_wallet_card.dart';
import '../../widgets/monthly_card.dart';




class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.user});

  final UserEntity user;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BillingBloc>().add(LoadBillingEvent(widget.user.id));
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
            curr is ReadingSavedSuccessState ||
                curr is ReadingDeletedState,
            listener: (context, state) {
              context.read<BillingBloc>().add(
                LoadBillingEvent(widget.user.id),
              );
              if(state is ReadingDeletedState){
               AppSnackBar.success(context, LocaleKeys.reading_deleted_success.tr());
              }
            },

          ),
          BlocListener<PaymentBloc, PaymentState>(
            listenWhen: (previous, current) =>
            previous.deleteSuccess != current.deleteSuccess,
            listener: (context, state) {
              if (state.deleteSuccess) {
                context.read<BillingBloc>().add(
                  LoadBillingEvent(widget.user.id),
                );
                AppSnackBar.success(context, LocaleKeys.payment_deleted_success.tr());
              }
            },

          ),

        ], child: BlocBuilder<BillingBloc, BillingState>(builder:
          (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(child: Text( "${LocaleKeys.generic_error.tr()} ${state.error}",));
        }
        if (state.summary == null) {
          return  Center(child: Text(LocaleKeys.no_billing_data.tr()));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16,
                      color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    widget.user.street,
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
                      label:  Text(LocaleKeys.add_reading.tr()),
                      onPressed: () async {
                        await NavigationManger.navigateTo(
                          context,
                          RouteNames.camera,
                          arguments: widget.user.id,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.attach_money),
                      label:  Text(LocaleKeys.add_payment.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGreen,
                      ),
                      onPressed: () {
                        showAddPaymentSheet(
                          context,
                          userId: widget.user.id,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(LocaleKeys.monthly_breakdown.t, style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.monthly.length,
                itemBuilder: (context, index) {
                  return MonthlyCard(month: state.monthly[index],
                    userId: widget.user.id,);
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

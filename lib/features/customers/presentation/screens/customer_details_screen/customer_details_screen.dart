import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/user_session.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';

import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/utils/app_dialog.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../../meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';
import '../../../../meter_reading/presentaion/blocs/meter_reading/meter_reading_event.dart';
import '../../../../meter_reading/presentaion/blocs/meter_reading/meter_reading_state.dart';
import '../../../domain/entities/customer_entity.dart';
import '../../blocs/customer_bloc/customer_bloc.dart';
import '../../blocs/customer_bloc/customer_event.dart';
import '../../blocs/customer_bloc/customer_state.dart';
import '../../widgets/customer_details_larg_card.dart';
import '../../widgets/reading_history_card.dart';

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
    context.read<MeterReadingBloc>().add(LoadReadingsEvent(widget.customer.id));
    context.read<MeterReadingBloc>().add(
      SyncOfflineReadingsEvent(widget.customer.id),
    );
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

      body: BlocListener<CustomerBloc, CustomerState>(
        listenWhen: (p, c) => p.deleteSuccess != c.deleteSuccess,
        listener: (context, state) {
          if (state.deleteSuccess) {
           AppSnackBar.success(context, "Customer deleted successfully");
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Customer Details", style: AppTextStyles.heading3),
              SizedBox(height: AppDimens.verticalSpace),

              CustomerLargeCard(customer: widget.customer),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Reading"),
                  onPressed: () async {
                    await NavigationManger.navigateTo(
                      context, RouteNames.camera,
                      arguments: widget.customer.id,);
                    context.read<MeterReadingBloc>().add(
                      LoadReadingsEvent(widget.customer.id),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Text("Reading History", style: AppTextStyles.heading3),
              const SizedBox(height: 5),
              Expanded(
                child: BlocBuilder<MeterReadingBloc, MeterReadingState>(
                  builder: (context, state) {
                    if (state is ReadingsLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ReadingsLoadedState) {
                      if (state.readings.isEmpty) {
                        return const Center(
                          child: Text("No readings found"),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.readings.length,
                        itemBuilder: (context, i) {
                          final r = state.readings[i];
                          return ReadingHistoryCard(reading: r , customerId: widget.customer.id,);
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentRed,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text("Delete Customer"),
                  onPressed: () => _onDeletePressed(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final confirmed = await AppDialog.showDeleteConfirm(
      context,
      title: "Delete Customer",
      message: "This action will permanently remove this customer and their readings.",
      confirmText: "Delete",
      cancelText: "Cancel",
    );

    if (confirmed == true) {
      context.read<CustomerBloc>().add(
        DeleteCustomerEvent(widget.customer.id),
      );
      context.read<CustomerBloc>().add(LoadCustomersEvent(UserSession.userId));
    }
  }

}

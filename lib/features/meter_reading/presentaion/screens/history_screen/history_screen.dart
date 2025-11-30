import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/history/history_state.dart';

import '../../../../../core/app_dimens.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/app_dialog.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../domain/entities/meter_reading_entity.dart';
import '../../blocs/history/history_bloc.dart';
import '../../blocs/history/history_event.dart';
import '../../widgets/history_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Reading History"),
      ),
      body: BlocConsumer<HistoryBloc,HistoryState >(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryLoaded) {
            final readings = state.readings;

            if (readings.isEmpty) {
              return const Center(
                child: Text(
                  "No readings saved yet",
                  style: AppTextStyles.subtitle,
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(AppDimens.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${readings.length} readings recorded",
                    style: AppTextStyles.bodySecondary,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final entry = readings[index];
                        final key = entry.key;
                        final MeterReadingEntity reading = entry.value;
                        return HistoryCard(
                          reading: reading,
                          onDelete: () => _onDeleteReading(context, key),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemCount: readings.length,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
        listener: (context, state) {
          if (state is HistoryError) {
            AppSnackBar.error(context, state.message);
          }
        },
      ),
    );
  }
  
  void _onDeleteReading(BuildContext context, dynamic key) async {
    final confirm = await AppDialog.showDeleteConfirm(
      context,
      title: "Delete Reading?",
      message: "This will permanently delete this meter reading. This action cannot be undone.",
      confirmText: "Delete",
      cancelText: "Cancel",
    );

    if (confirm == true) {
      context.read<HistoryBloc>().add(DeleteReadingEvent(key));
      AppSnackBar.success(context, "Reading deleted successfully");
    }
  }

}

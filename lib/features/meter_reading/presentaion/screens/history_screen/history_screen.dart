import 'package:flutter/material.dart';
import '../../../../../core/utils/app_dialog.dart';
import '../../../../../core/utils/app_snackbar.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // return Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       icon: const Icon(Icons.arrow_back),
    //       onPressed: () => Navigator.pop(context),
    //     ),
    //     title: const Text("Reading History"),
    //   ),
    //   body: BlocConsumer<HistoryBloc,HistoryState >(
    //     builder: (context, state) {
    //       if (state is HistoryLoading) {
    //         return const Center(child: CircularProgressIndicator());
    //       }
    //       if (state is HistoryLoaded) {
    //         final readings = state.readings;
    //
    //         if (readings.isEmpty) {
    //           return const Center(
    //             child: Text(
    //               "No readings saved yet",
    //               style: AppTextStyles.subtitle,
    //             ),
    //           );
    //         }
    //         return Padding(
    //           padding: const EdgeInsets.all(AppDimens.paddingLarge),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "${readings.length} readings recorded",
    //                 style: AppTextStyles.bodySecondary,
    //               ),
    //               const SizedBox(height: 16),
    //               Expanded(
    //                 child: ListView.separated(
    //                   itemBuilder: (context, index) {
    //                     final entry = readings[index];
    //                     final key = entry.key;
    //                     final MeterReadingEntity reading = entry.value;
    //                     return HistoryCard(
    //                       reading: reading,
    //                       onDelete: () => _onDeleteReading(context, key),
    //                     );
    //                   },
    //                   separatorBuilder: (_, __) => const SizedBox(height: 20),
    //                   itemCount: readings.length,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //       }
    //       return const SizedBox();
    //     },
    //     listener: (context, state) {
    //       if (state is HistoryError) {
    //         AppSnackBar.error(context, state.message);
    //       }
    //     },
    //   ),
    // );
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
      // context.read<HistoryBloc>().add(DeleteReadingEvent(key));
      AppSnackBar.success(context, "Reading deleted successfully");
    }
  }

}

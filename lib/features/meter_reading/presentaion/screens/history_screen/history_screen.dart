import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_dialog.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/theme/app_text_style.dart';

import '../../blocs/history_bloc/history_bloc.dart';
import '../../blocs/history_bloc/history_event.dart';
import '../../blocs/history_bloc/history_state.dart';
import '../../widgets/history_list_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});



  @override
  Widget build(BuildContext context) {

    context.read<HistoryBloc>().add(LoadAllReadingsEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Readings History"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: BlocConsumer<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistoryError) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HistoryLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return const Center(
                child: Text("No readings found", style: AppTextStyles.subtitle),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(AppDimens.paddingLarge),
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return HistoryListItem(
                    user: item.user,
                    reading: item.reading,
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

}

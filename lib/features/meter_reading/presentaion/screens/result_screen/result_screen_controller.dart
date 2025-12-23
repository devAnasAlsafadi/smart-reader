import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/utils/app_dialog.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/meter_reading/meter_reading_event.dart';
import '../../../data/repositories/meter_reading_repository_impl.dart';
import '../../blocs/meter_reading/meter_reading_state.dart';

class ResultScreenController {
  ResultScreenController({
    required this.context,
    required this.entity,
    required this.onReadingUpdated,
  });

  final BuildContext context;
  final MeterReadingEntity entity;
  final VoidCallback onReadingUpdated;

  void saveReading() {
    context.read<MeterReadingBloc>().add(SaveReadingEvent(entity: entity));
  }

  void tryAgain() {
    NavigationManger.navigateAndReplace(
      context,
      RouteNames.camera,
      arguments: entity.userId,
    );
  }

  Future<void> editReading() async {
    final updated = await NavigationManger.navigateTo(
      context,
      RouteNames.editReadingScreen,
      arguments: entity.meterValue,
    );

    if (updated != null) {
      entity.meterValue = updated;
      onReadingUpdated();
    }
  }

  Future<void> onBlocStateChanged(
    BuildContext context,
    MeterReadingState state,
  ) async {
    if (state is ReadingSavedLoadingState) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }

    if (state is ReadingSavedSuccessState) {
      Navigator.pop(context);
      final r = state.result;

      if (r.type == ReadingResultType.localCalculated) {
        await AppDialog.showReadingResult(
          context,
          result: r
        );
      }

      if (r.type == ReadingResultType.cloudPending) {
        await AppDialog.showReadingResult(
          context,
         result: r
        );
      }

      NavigationManger.pushNamedAndRemoveUntil(context, RouteNames.home);
    }

    if (state is ReadingSavedFailureState) {
      print('failure');
      Navigator.pop(context);
      AppSnackBar.error(context, state.message);
    }
  }
}

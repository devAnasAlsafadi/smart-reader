// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/result_screen/result_screen_controller.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/result_screen/widgets/confidence_bar.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/result_screen/widgets/reading_value_card.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/result_screen/widgets/result_actions_row.dart';
import 'package:smart_reader/features/meter_reading/presentaion/screens/result_screen/widgets/result_header.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Features – Meter Reading
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/meter_reading/meter_reading_state.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.entity});

  final MeterReadingEntity entity;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ResultScreenController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = ResultScreenController(
      context: context,
      entity: widget.entity,
      onReadingUpdated: () => setState(() {}),
    );
  }
  Widget _confirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _controller.saveReading,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGreen,
        ),
        child: Text(LocaleKeys.confirm_reading.t),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    return BlocListener<MeterReadingBloc, MeterReadingState>(
      listener:  _controller.onBlocStateChanged,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const ResultHeader(),
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.accentGreen.withValues(alpha: .15),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.accentGreen,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ReadingValueCard(value: widget.entity.meterValue),
              const SizedBox(height: 24),
              const ConfidenceBar(),
              const Spacer(),
              _confirmButton(),
              const SizedBox(height: 16),
              ResultActionsRow(
                onEdit: _controller.editReading,
                onRetry: _controller.tryAgain,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

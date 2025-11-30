import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:smart_reader/core/app_dimens.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/history/history_state.dart';
import 'package:smart_reader/features/meter_reading/presentaion/widgets/action_button.dart';

import '../../../../../core/app_assets.dart';
import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../../../core/utils/app_bottom_sheets.dart';
import '../../../domain/entities/meter_reading_entity.dart';
import '../../blocs/history/history_bloc.dart';
import '../../blocs/history/history_event.dart';
import '../../blocs/meter_reading/meter_reading_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HistoryBloc>().add(LoadHistoryEvent());

    return BlocListener<MeterReadingBloc, MeterReadingState>(
      listener: (context, state) {
        if (state is ImagePickedSuccess) {}
        if (state is MeterReadingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppDimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MeterScan', style: AppTextStyles.heading2),
                        SizedBox(height: 4),
                        Text(
                          "AI-Powered Meter Reader",
                          style: AppTextStyles.subtitle,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: AppColors.textPrimary,
                        size: AppDimens.iconSize,
                      ),
                      onPressed: () {
                        NavigationManger.navigateTo(
                          context,
                          RouteNames.settings,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.verticalSpaceLarge),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppDimens.paddingLarge),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusLarge,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryLight.withValues(alpha: 0.12),
                          AppColors.primaryLight.withValues(alpha: 0.04),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppDimens.padding),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            AppAssets.logo,
                            width: 48,
                            height: 48,
                          ),
                        ),
                        const SizedBox(height: AppDimens.verticalSpaceLarge),
                        Text(
                          "Scan your electricity meter and get accurate readings instantly \n using AI",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.verticalSpaceLarge),
                BlocBuilder<HistoryBloc, HistoryState>(
                  builder: (context, state) {
                    if (state is HistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is HistoryLoaded && state.readings.isNotEmpty) {
                      final lastEntry = state.readings.last.value;

                      return _buildLatestReadingCard(lastEntry);
                    }
                    return _buildEmptyLatestReadingCard();
                  },
                ),
                const SizedBox(height: AppDimens.verticalSpaceLarge),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      AppBottomSheets.showScanOptions(
                        context: context,
                        onCamera: () {
                          // context.read<MeterReadingBloc>().add(
                          //     PickFromCameraEvent());
                          NavigationManger.navigateTo(
                            context,
                            RouteNames.camera,
                          );
                        },
                        onGallery: () {
                          // context.read<MeterReadingBloc>().add(
                          //     PickFromGalleryEvent());
                        },
                      );
                    },
                    child: const Text("⚡   Scan Meter"),
                  ),
                ),
                const SizedBox(height: AppDimens.verticalSpaceLarge),
                Row(
                  children: [
                    ActionButton(
                      label: 'View History',
                      icon: Icons.history,
                      onTap: () {
                        NavigationManger.navigateTo(
                          context,
                          RouteNames.history,
                        );
                      },
                    ),
                    SizedBox(width: 10),
                    ActionButton(
                      label: 'Guide',
                      icon: Icons.help_outline,
                      onTap: () {
                        NavigationManger.navigateTo(context, RouteNames.guide);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatestReadingCard(MeterReadingEntity last) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, color: AppColors.primary, size: 35),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Latest Reading", style: AppTextStyles.subtitle),
                Text("${last.reading} kWh",
                    style: AppTextStyles.heading2),
                const SizedBox(height: 4),
                Text(
                  DateFormat("dd/MM/yyyy  |  hh:mm a")
                      .format(last.timestamp),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyLatestReadingCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, color: AppColors.primary, size: 35),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "No readings saved yet",
              style: AppTextStyles.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}

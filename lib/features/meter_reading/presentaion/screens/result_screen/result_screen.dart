import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';

import '../../../../../core/app_dimens.dart';
import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../widgets/action_button.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({
    super.key,
    required this.reading,
    required this.imagePath,
  });

  String reading;
  final String imagePath;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MeterReadingBloc, MeterReadingState>(
      listener: (context, state) {
        if (state is ReadingSavedLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ReadingSavedSuccessState) {
          AppSnackBar.success(context, "Reading saved successfully!");
          NavigationManger.pushNamedAndRemoveUntil(context, RouteNames.home);
        }

        if (state is ReadingSavedFailureState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => NavigationManger.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reading Extracted', style: AppTextStyles.heading1),
              Text('AI has detected the following value',
                style: AppTextStyles.bodySecondary,),

              SizedBox(height: 50),
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
              const SizedBox(height: 20),
              Align(alignment: Alignment.center, child: _buildReadingCard()),
              const SizedBox(height: 25),
              _buildConfidenceBar(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<MeterReadingBloc>().add(
                      SaveSelectedReadingEvent(
                        selectedReading: widget.reading,
                        imagePath: widget.imagePath,
                      ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                  ),
                  child: const Text("Confirm Reading"),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      icon: Icons.edit_outlined,
                      label: "Edit",
                      onTap: () async {
                        final updated = await NavigationManger.navigateTo(
                            context,
                            RouteNames.editReadingScreen,
                            arguments: widget.reading
                        );
                        if (updated != null && updated is String) {
                          setState(() {
                            widget.reading = updated;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ActionButton(
                      icon: Icons.refresh_outlined,
                      label: "Try Again",
                      onTap: () {
                        NavigationManger.navigateAndReplace(context, RouteNames.camera);
                        // NavigationManger.pushNamedAndRemoveUntil(context, RouteNames.camera,);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text("Meter Reading", style: AppTextStyles.subtitle),
          const SizedBox(height: 10),
          Text(widget.reading,
              style: AppTextStyles.heading1.copyWith(fontSize: 30)),
          const SizedBox(height: 5),
          const Text("kWh", style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildConfidenceBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.accentGreen),
              const SizedBox(width: 8),
              const Text("Confidence", style: AppTextStyles.subtitle),
              const Spacer(),
              Text(
                "96%",
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.96,
              minHeight: 8,
              color: AppColors.accentGreen,
              backgroundColor: AppColors.border,
            ),
          ),
        ],
      ),
    );
  }
}


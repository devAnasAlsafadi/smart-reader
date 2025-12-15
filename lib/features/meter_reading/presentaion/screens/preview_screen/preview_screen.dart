// Dart
import 'dart:io';

// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Third-party
import 'package:uuid/uuid.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';

// Features – Meter Reading
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';
import '../../blocs/meter_reading/meter_reading_bloc.dart';
import '../../blocs/meter_reading/meter_reading_event.dart';
import '../../blocs/meter_reading/meter_reading_state.dart';

class PreviewScreen extends StatefulWidget {
  final File imageFile;
  final String customerId;

  const PreviewScreen({
    super.key,
    required this.imageFile,
    required this.customerId,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isProcessing = false;
  String _rawText = '';
  List<String> _digits = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeterReadingBloc, MeterReadingState>(
      listener: (context, state) async {
        if (state is OcrProcessingState) {
          if (!mounted) return;
          setState(() {
            _isProcessing = true;
          });     }
        if (state is OcrTextReadyState) {
          if (!mounted) return;
          setState(() {
            _isProcessing = false;
          });
          _rawText = state.rawText;
          context.read<MeterReadingBloc>().add(ExtractDigitsEvent(_rawText));
        }
        if (state is DigitsExtractedState) {
          if (!mounted) return;
          setState(() {
            _isProcessing = false;
          });
          _digits = state.digits;
          NavigationManger.navigateTo(
            context,
            RouteNames.extractReadingScreen,
            arguments: {
              'readings': _digits,
              'rawText': _rawText,
              'entity': entity,
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(LocaleKeys.preview_photo.t),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(  LocaleKeys.review_captured_image.t, style: AppTextStyles.subtitle),
              const SizedBox(height: AppDimens.verticalSpaceLarge),
              Expanded(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(AppDimens.padding),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusLarge,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.radius),
                      child: Image.file(
                        widget.imageFile,
                        width: 260,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.verticalSpaceLarge * 2),
              _isProcessing
                  ? Align(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(LocaleKeys.extract_reading.t),
                        onPressed: () async {
                          context.read<MeterReadingBloc>().add(
                            ProcessImageEvent(widget.imageFile),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: AppDimens.verticalSpaceLarge),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => NavigationManger.pop(context),
                  icon: const Icon(Icons.refresh),
                  label: Text(LocaleKeys.retake_photo.t),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusLarge,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  MeterReadingEntity get entity {
    return MeterReadingEntity(
      id: const Uuid().v4(),
      customerId: widget.customerId,
      meterValue: 0.0,
      cost: 0.0,
      consumption: 0.0,
      imagePath: widget.imageFile.path,
      timestamp: DateTime.now(),
      synced: false,
    );
  }
}

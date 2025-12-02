import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/app_dimens.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';
import '../../blocs/meter_reading/meter_reading_bloc.dart';

class PreviewScreen extends StatefulWidget {
  final File imageFile;
  const PreviewScreen({super.key, required this.imageFile});

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
          _isProcessing = true;
          setState(() {});
        }
        if (state is OcrTextReadyState) {
          _isProcessing = false;
          _rawText = state.rawText;
          setState(() {});
          context.read<MeterReadingBloc>().add(ExtractDigitsEvent(_rawText));
        }
        if (state is DigitsExtractedState) {
          _isProcessing = false;
          _digits = state.digits;
          setState(() {});

          print('_rawText is :$_rawText');
          NavigationManger.navigateTo(
            context,
            RouteNames.extractReadingScreen,
            arguments: {
              'readings': _digits,
              'rawText': _rawText,
              'imagePath': widget.imageFile.path,
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Preview photo'), centerTitle: true),
        body: Padding(
          padding: EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Review your captured image', style: AppTextStyles.subtitle),
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
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text("Extract Reading"),
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
                  label: const Text("Retake Photo"),
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
}

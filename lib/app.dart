import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_reader/features/meter_reading/data/services/ocr_service.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/delete_reading_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/get_all_readings_usecase.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/history/history_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/routes/route_name.dart';
import 'core/theme/theme.dart';
import 'features/meter_reading/data/repositories/meter_reading_repository..dart';
import 'features/meter_reading/data/services/image_picker_service.dart';
import 'features/meter_reading/domain/usecases/extract_digits_usecase.dart';
import 'features/meter_reading/domain/usecases/process_image_usecase.dart';
import 'features/meter_reading/domain/usecases/save_reading_usecase.dart';
import 'features/meter_reading/presentaion/blocs/history/history_event.dart';
import 'features/meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';

class SmartReaderApp extends StatelessWidget {
  const SmartReaderApp({super.key});

  @override
  Widget build(BuildContext context) {

    final meterReadingRepo = MeterReadingRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MeterReadingBloc(
            imagePickerService: ImagePickerService(),
            processImageUseCase: ProcessImageUseCase(OcrService()),
            extractDigitsUseCase: ExtractDigitsUseCase(),
            saveReadingUseCase: SaveReadingUseCase(meterReadingRepo),
          ),

        ),
        BlocProvider(create: (context) => HistoryBloc(getAllReadingsUseCase: GetAllReadingsUseCase(meterReadingRepo), deleteReadingUseCase: DeleteReadingUseCase(meterReadingRepo))..add(LoadHistoryEvent()),)
      ],
      child: MaterialApp(
        title: 'Smart Meter Reader',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: RouteNames.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
        builder: (context, child) {
          return ResponsiveBreakpoints(
            breakpoints: [
              Breakpoint(start: 0, end: 450, name: MOBILE),
              Breakpoint(start: 451, end: 800, name: TABLET),
              Breakpoint(start: 801, end: 1920, name: DESKTOP),
              Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
            child: child!,
          );
        },
      ),
    );
  }
}

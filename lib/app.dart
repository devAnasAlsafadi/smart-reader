import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_reader/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:smart_reader/features/auth/domain/usecases/login_usecase.dart';
import 'package:smart_reader/features/auth/domain/usecases/logout_usecase.dart';
import 'package:smart_reader/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:smart_reader/features/customers/data/data_source/customer_local_data_source.dart';
import 'package:smart_reader/features/customers/data/data_source/customer_remote_data_source.dart';
import 'package:smart_reader/features/customers/data/models/customer_model.dart';
import 'package:smart_reader/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:smart_reader/features/meter_reading/data/data_source/meter_reading_local_data_source.dart';
import 'package:smart_reader/features/meter_reading/data/data_source/meter_reading_remote_data_source.dart';
import 'package:smart_reader/features/meter_reading/data/services/ocr_service.dart';
import 'package:smart_reader/features/meter_reading/data/services/upload_service.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/add_reading_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/delete_reading_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/extract_digits_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/get_readings_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/process_image_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/sync_offline_readings_usecase.dart';

import 'core/routes/app_router.dart';
import 'core/routes/route_name.dart';
import 'core/theme/theme.dart';
import 'features/auth/data/data_source/auth_local_data_source.dart';
import 'features/auth/data/data_source/auth_remote_data_source.dart';
import 'features/auth/data/models/user_model.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/customers/domain/usecases/add_customer_usercase.dart';
import 'features/customers/domain/usecases/delete_customer_usecase.dart';
import 'features/customers/domain/usecases/get_customers_usecase.dart';
import 'features/customers/domain/usecases/sync_offline_customer_usecase.dart';
import 'features/customers/presentation/blocs/customer_bloc/customer_bloc.dart';
import 'features/meter_reading/data/models/meter_reading_model.dart';
import 'features/meter_reading/data/repositories/meter_reading_repository_impl.dart';
import 'features/meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';

class SmartReaderApp extends StatelessWidget {
  const SmartReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final meterReadingRepo = MeterReadingRepositoryImpl(
      MeterReadingLocalDataSourceImpl(
        Hive.box<MeterReadingModel>("meter_reading_box"),
      ),
      MeterReadingRemoteDataSourceImpl(),
      UploadService(),
    );
    final customerRepo = CustomerRepositoryImpl(
      CustomerLocalDataSourceImpl(Hive.box<CustomerModel>("customer_box")),
      CustomerRemoteDataSourceImpl(),
    );
    final authRepository = AuthRepositoryImpl(
      AuthLocalDataSourceImpl(Hive.box<UserModel>("user_box")),
      AuthRemoteDataSourceImpl(),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MeterReadingBloc(
            addReading: AddReadingUseCase(meterReadingRepo),
            deleteReading: DeleteReadingUseCase(meterReadingRepo),
            getReadings: GetReadingsUseCase(meterReadingRepo),
            syncOffline: SyncOfflineReadingsUseCase(meterReadingRepo),
            extractDigits: ExtractDigitsUseCase(),
            processImage: ProcessImageUseCase(OcrService()),
          ),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: LoginUseCase(authRepository),
            logoutUseCase: LogoutUseCase(authRepository),
            getCurrentUserUseCase: GetCurrentUserUseCase(authRepository),
          ),
        ),
        BlocProvider(
          create: (_) => CustomerBloc(
            addCustomer: AddCustomerUseCase(customerRepo),
            getCustomers: GetCustomersUseCase(customerRepo),
            deleteCustomer: DeleteCustomerUseCase(customerRepo),
            syncCustomers: SyncOfflineCustomersUseCase(customerRepo),
          ),
        ),
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

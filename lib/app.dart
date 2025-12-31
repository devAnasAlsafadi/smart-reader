
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_reader/features/app_settings/data/data_sources/app_settings_remote.dart';
import 'package:smart_reader/features/app_settings/domain/usecases/sync_billing_settings_usecase.dart';
import 'package:smart_reader/features/auth/domain/usecases/get_current_employee_usecase.dart';
import 'package:smart_reader/features/auth/domain/usecases/login_usecase.dart';
import 'package:smart_reader/features/auth/domain/usecases/logout_usecase.dart';
import 'package:smart_reader/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:smart_reader/features/electrical_panels/data/data_sources/electrical_panels_local.dart';
import 'package:smart_reader/features/electrical_panels/data/models/electrical_panel_model.dart';
import 'package:smart_reader/features/electrical_panels/domain/usecases/get_electrical_panels.dart';
import 'package:smart_reader/features/electrical_panels/presentation/blocs/panel_bloc/panel_bloc.dart';
import 'package:smart_reader/features/meter_reading/data/data_source/meter_reading_local_data_source.dart';
import 'package:smart_reader/features/meter_reading/data/data_source/meter_reading_remote_data_source.dart';
import 'package:smart_reader/features/meter_reading/data/services/meter_ocr_service.dart';
import 'package:smart_reader/features/meter_reading/data/services/ocr_service.dart';
import 'package:smart_reader/features/meter_reading/data/services/upload_service.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/add_reading_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/delete_reading_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/extract_digits_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/get_readings_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/listen_to_reading_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/process_image_usecase.dart';
import 'package:smart_reader/features/meter_reading/domain/usecases/sync_offline_readings_usecase.dart';
import 'package:smart_reader/features/meter_reading/presentaion/blocs/history_bloc/history_bloc.dart';
import 'package:smart_reader/features/payments/data/data_source/payment_local_data_source.dart';
import 'package:smart_reader/features/payments/data/data_source/payment_remote_data_source.dart';
import 'package:smart_reader/features/payments/data/model/payment_model.dart';
import 'package:smart_reader/features/payments/data/repositories/payment_repositories_impl.dart';
import 'package:smart_reader/features/payments/data/services/billing_calculator.dart';
import 'package:smart_reader/features/payments/domain/usecases/add_payment_usecase.dart';
import 'package:smart_reader/features/payments/domain/usecases/calculate_billing_useCase.dart';
import 'package:smart_reader/features/payments/domain/usecases/delete_payment_usecase.dart';
import 'package:smart_reader/features/payments/domain/usecases/get_payments_usecase.dart';
import 'package:smart_reader/features/payments/domain/usecases/sync_offline_payments_usecase.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/billing_bloc/billing_bloc.dart';
import 'package:smart_reader/features/payments/presentaion/blocs/payment_bloc/payment_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/routes/route_name.dart';
import 'core/theme/theme.dart';
import 'features/app_settings/data/data_sources/app_settings_local.dart';
import 'features/app_settings/data/repositories/app_settings_repository_impl.dart';
import 'features/app_settings/domain/usecases/get_billing_settings_usecase.dart';
import 'features/auth/data/data_source/auth_local_data_source.dart';
import 'features/auth/data/data_source/auth_remote_data_source.dart';
import 'features/auth/data/models/employee_model.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

import 'features/electrical_panels/data/data_sources/electrical_panels_remote.dart';
import 'features/electrical_panels/data/repositories/electrical_panels_repo_impl.dart';
import 'features/meter_reading/data/models/meter_reading_model.dart';
import 'features/meter_reading/data/repositories/meter_reading_repository_impl.dart';
import 'features/meter_reading/presentaion/blocs/meter_reading/meter_reading_bloc.dart';
import 'features/users/data/data_source/user_local_data_source.dart';
import 'features/users/data/data_source/user_remote_data_source.dart';
import 'features/users/data/models/user_model.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/usecases/add_user_usercase.dart';
import 'features/users/domain/usecases/delete_user_usecase.dart';
import 'features/users/domain/usecases/get_users_usecase.dart';
import 'features/users/domain/usecases/sync_offline_user_usecase.dart';
import 'features/users/presentation/blocs/user_bloc/user_bloc.dart';

class SmartReaderApp extends StatefulWidget {
  const SmartReaderApp(this.ocrService,{super.key,});
  final MeterOcrService ocrService;

  @override
  State<SmartReaderApp> createState() => _SmartReaderAppState();
}

class _SmartReaderAppState extends State<SmartReaderApp> {
  late final MeterReadingRepositoryImpl meterReadingRepo;
  late final UserRepositoryImpl userRepo;
  late final AuthRepositoryImpl authRepository;
  late final PaymentRepositoryImpl paymentRepository;
  late final ElectricalPanelRepositoryImpl panelRepository;
  late final AppRouter _appRouter;


  @override
  void initState() {
    super.initState();

    final appSettingsRepo = AppSettingsRepositoryImpl(
      AppSettingsLocalDataSourceImpl(Hive.box('settings_box')),
      AppSettingsRemoteDataSource(),
    );

    final   getBillingSettings = GetBillingSettingsUseCase(appSettingsRepo);
    final   syncBillingSettingsUseCase = SyncBillingSettingsUseCase(appSettingsRepo);

    meterReadingRepo = MeterReadingRepositoryImpl(
      MeterReadingLocalDataSourceImpl(
        Hive.box<MeterReadingModel>("meter_reading_box"),
      ),
      MeterReadingRemoteDataSourceImpl(),
      UploadService(),
        getBillingSettings


    );
    panelRepository = ElectricalPanelRepositoryImpl(ElectricalPanelLocalDataSourceImpl(Hive.box<ElectricalPanelModel>("panel_box")),ElectricalPanelRemoteDataSourceImpl() );

    userRepo = UserRepositoryImpl(
      UserLocalDataSourceImpl(Hive.box<UserModel>("user_box")),
      UserRemoteDataSourceImpl(),
    );

    authRepository = AuthRepositoryImpl(
      AuthLocalDataSourceImpl(Hive.box<EmployeeModel>("employee_box")),
      AuthRemoteDataSourceImpl(),
    );

    paymentRepository = PaymentRepositoryImpl(
      PaymentLocalDataSourceImpl(Hive.box<PaymentModel>("payment_box")),
      PaymentRemoteDataSourceImpl(),
    );
    _appRouter = AppRouter(
      getBillingSettings: getBillingSettings,
      syncBillingSettings: syncBillingSettingsUseCase,
    );
  }




  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MeterReadingBloc(
            watchReading: ListenToReadingUsecase(meterReadingRepo),
            addReading: AddReadingUseCase(meterReadingRepo),
            deleteReading: DeleteReadingUseCase(meterReadingRepo),
            getReadings: GetReadingsUseCase(meterReadingRepo),
            syncOffline: SyncOfflineReadingsUseCase(meterReadingRepo),
            extractDigits: ExtractDigitsUseCase(),
            processImage: ProcessImageUseCase(widget.ocrService),
          ),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: LoginUseCase(authRepository),
            logoutUseCase: LogoutUseCase(authRepository),
            getCurrentEmployeeUseCase: GetCurrentEmployeeUseCase(
              authRepository,
            ),
          ),
        ),
        BlocProvider(
          create: (_) => UserBloc(
            addUser: AddUserUseCase(userRepo),
            getUsers: GetUsersUseCase(userRepo),
            deleteUser: DeleteUserUseCase(userRepo),
            syncUsers: SyncOfflineUsersUseCase(userRepo),
          ),
        ),
        BlocProvider(
          create: (_) => PaymentBloc(
            addPaymentUseCase: AddPaymentUseCase(paymentRepository),
            deletePaymentUseCase: DeletePaymentUseCase(paymentRepository),
            getPaymentsUseCase: GetPaymentsUseCase(paymentRepository),
            syncOfflinePaymentsUseCase: SyncOfflinePaymentsUseCase(
              paymentRepository,
            ),
          ),
        ),
        BlocProvider(
          create: (_) => BillingBloc(
            getReadings: GetReadingsUseCase(meterReadingRepo),
            getPayments: GetPaymentsUseCase(paymentRepository),
            calculateBilling: CalculateBillingUseCase(BillingCalculator()),
          ),
        ),
        BlocProvider(
          create: (_) => PanelBloc(
            getPanels: GetElectricalPanelsUseCase(panelRepository)
          ),
        ),
        BlocProvider(
          create: (_) => HistoryBloc(
            getReadings: GetReadingsUseCase(meterReadingRepo),
            deleteReading: DeleteReadingUseCase(meterReadingRepo),
            getUsers: GetUsersUseCase(userRepo),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Smart Reader',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.lightTheme,
        initialRoute: RouteNames.splash,
        onGenerateRoute: _appRouter.onGenerateRoute,
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

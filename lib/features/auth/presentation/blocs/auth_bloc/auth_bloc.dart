import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/user_session.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/usecases/get_current_employee_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentEmployeeUseCase getCurrentEmployeeUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentEmployeeUseCase,
  }) : super(AuthInitial()) {

    on<LoginEvent>((event, emit) async{
      emit(AuthLoading());
      try {
        final employee = await loginUseCase(event.email, event.password);
        emit(AuthAuthenticated(employee));
      } catch (e) {
        emit(AuthError("Invalid email or password : $e"));
      }
    },);

    on<CheckAuthEvent>((event, emit) async {
      final employee = await getCurrentEmployeeUseCase();
      if (employee != null && employee.token!.isNotEmpty) {
        emit(AuthAuthenticated(employee));
      } else {
        emit(AuthUnauthenticated());
      }
    });


    on<LogoutEvent>((event, emit) async {
      try{
        await logoutUseCase();
        await EmployeeSession.clear();
        emit(AuthUnauthenticated());
        emit(LogoutSuccess());
      }catch (e){
        emit(LogoutError(e.toString()));
      }


    });
  }


}


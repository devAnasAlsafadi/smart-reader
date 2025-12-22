part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}


class AuthAuthenticated extends AuthState {
  final EmployeeEntity employee;
  AuthAuthenticated(this.employee);
}

class AuthUnauthenticated extends AuthState {}


class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
class LogoutError extends AuthState {
  final String message;
  LogoutError(this.message);
}
class LogoutSuccess extends AuthState {}


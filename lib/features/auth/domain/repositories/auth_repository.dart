import '../entities/employee_entity.dart';

abstract class AuthRepository {
  Future<EmployeeEntity> login(String email, String password);
  Future<void> logout();
  Future<EmployeeEntity?> getCurrentEmployee();
}
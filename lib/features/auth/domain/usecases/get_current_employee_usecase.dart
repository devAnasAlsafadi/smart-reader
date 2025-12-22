import '../entities/employee_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentEmployeeUseCase {
  final AuthRepository repository;

  GetCurrentEmployeeUseCase(this.repository);

  Future<EmployeeEntity?> call() {
    return repository.getCurrentEmployee();
  }
}

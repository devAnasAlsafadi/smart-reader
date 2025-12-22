import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_source/auth_local_data_source.dart';
import '../data_source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource local;
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.local, this.remote);

  @override
  Future<EmployeeEntity> login(String email, String password) async {
    final remoteEmployee = await remote.login(email, password);
    await local.saveEmployee(remoteEmployee);
    return remoteEmployee;
  }

  @override
  Future<EmployeeEntity?> getCurrentEmployee() async {
    return await local.getEmployee();
  }

  @override
  Future<void> logout() async {
    await local.clearEmployee();
  }
}

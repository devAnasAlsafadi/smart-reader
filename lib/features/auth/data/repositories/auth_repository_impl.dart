import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_source/auth_local_data_source.dart';
import '../data_source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource local;
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.local, this.remote);

  @override
  Future<UserEntity> login(String email, String password) async {
    final remoteUser = await remote.login(email, password);
    await local.saveUser(remoteUser);
    return remoteUser;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await local.getUser();
  }

  @override
  Future<void> logout() async {
    await local.clearUser();
  }
}

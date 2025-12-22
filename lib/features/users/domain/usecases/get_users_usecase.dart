
import 'package:smart_reader/features/users/domain/entities/user_entity.dart';

import '../repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;
  GetUsersUseCase(this.repository);
  Future<List<UserEntity>> call(String employeeId) async {
    return await repository.getUsers(employeeId);
  }

}
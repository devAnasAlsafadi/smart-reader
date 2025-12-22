
import 'package:smart_reader/features/users/domain/entities/user_entity.dart';

import '../repositories/user_repository.dart';

class AddUserUseCase{
  final UserRepository repository;
  AddUserUseCase(this.repository);

  Future<void> call (UserEntity entity) async {
    await repository.addUser(entity);
  }

}
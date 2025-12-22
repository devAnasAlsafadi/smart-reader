
import '../repositories/user_repository.dart';

class SyncOfflineUsersUseCase {
  final UserRepository repository;
  SyncOfflineUsersUseCase(this.repository);
  Future<void> call(String userId) async {
    return await repository.syncOfflineUsers(userId);
  }
}
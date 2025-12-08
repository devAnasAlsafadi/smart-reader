import 'package:hive/hive.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel model);
  Future<UserModel?> getUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> box;

  AuthLocalDataSourceImpl(this.box);

  @override
  Future<void> saveUser(UserModel model) async {
    await box.put("user", model);
  }

  @override
  Future<UserModel?> getUser() async {
    return box.get("user");
  }

  @override
  Future<void> clearUser() async {
    await box.delete("user");
  }
}

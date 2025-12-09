import 'package:hive/hive.dart';

import '../features/auth/data/models/user_model.dart';

class UserSession {
  static UserModel? get currentUser {
    final box = Hive.box<UserModel>("user_box");
    return box.get("user");
  }

  static String get userId => currentUser?.id ?? "";
  static String get userName => currentUser?.name ?? "";
  static Future<void> clear() async {
    final box = Hive.box<UserModel>("user_box");
    await box.delete("user");
  }
}

import 'package:hive/hive.dart';

import '../features/auth/data/models/employee_model.dart';

class EmployeeSession {
  static EmployeeModel? get currentEmployee {
    final box = Hive.box<EmployeeModel>("employee_box");
    return box.get("employee");
  }

  static String get employeeId => currentEmployee?.id ?? "";
  static String get employeeName => currentEmployee?.name ?? "";
  static Future<void> clear() async {
    final box = Hive.box<EmployeeModel>("employee_box");
    await box.delete("employee");
  }
}

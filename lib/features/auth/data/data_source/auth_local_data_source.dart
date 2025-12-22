import 'package:hive/hive.dart';
import '../models/employee_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveEmployee(EmployeeModel model);
  Future<EmployeeModel?> getEmployee();
  Future<void> clearEmployee();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<EmployeeModel> box;

  AuthLocalDataSourceImpl(this.box);

  @override
  Future<void> saveEmployee(EmployeeModel model) async {
    await box.put("employee", model);
  }

  @override
  Future<EmployeeModel?> getEmployee() async {
    return box.get("employee");
  }




  @override
  Future<void> clearEmployee() async {
    await box.delete("employee");
  }


}

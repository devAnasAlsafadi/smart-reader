import 'package:hive/hive.dart';
import '../../domain/entities/employee_entity.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 1)
class EmployeeModel extends EmployeeEntity {
  @HiveField(0)
  final String employeeIdHive;

  @HiveField(1)
  final String nameHive;

  @HiveField(2)
  final String emailHive;

  @HiveField(3)
  final String? tokenHive;

  @HiveField(4)
  final String phoneNumberHive;

  @HiveField(5)
  final String addressHive;

  @HiveField(6)
  final int idNumberHive;

  @HiveField(7)
  final String specialistHive;

  EmployeeModel({
    required this.employeeIdHive,
    required this.nameHive,
    required this.emailHive,
    required this.specialistHive,
    required this.idNumberHive,
    required this.addressHive,
     this.tokenHive,
    required this.phoneNumberHive,
  }) : super(name: nameHive,phoneNumber: phoneNumberHive,email: emailHive,address: addressHive,id: employeeIdHive,idNumber: idNumberHive,specialist: specialistHive,token: tokenHive);

  factory EmployeeModel.fromFireStore(
    String uid,
    Map<String, dynamic> json,
    String token
  ) {
    return EmployeeModel(
      employeeIdHive: uid,
      nameHive: json["name"] ?? "",
      emailHive: json["email"] ?? "",
      specialistHive: json["specialist"] ?? "",
      addressHive: json["address"] ?? "",
      idNumberHive: json["idNumber"] ?? 0,
      phoneNumberHive: json["phoneNumber"] ?? "",
      tokenHive: token
    );
  }



}

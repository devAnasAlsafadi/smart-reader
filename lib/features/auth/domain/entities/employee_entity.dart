class EmployeeEntity {

  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? token;
  final String address;
  final int idNumber;
  final String specialist;


  const EmployeeEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.idNumber,
    required this.specialist,
     this.token,
  });

  static final empty  = EmployeeEntity(id: '', email: '', name: '', phoneNumber:''  ,token: '', address: '', idNumber: 0, specialist: '');


}

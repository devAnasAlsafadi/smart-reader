class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.token,
  });

  static final empty  = UserEntity(id: '', email: '', name: '', phoneNumber:''  ,token: '');


}

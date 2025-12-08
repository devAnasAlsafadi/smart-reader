import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends UserEntity {
  @HiveField(0)
  final String userIdHive;

  @HiveField(1)
  final String nameHive;

  @HiveField(2)
  final String emailHive;

  @HiveField(3)
  final String tokenHive;

  @HiveField(4)
  final String phoneHive;

  UserModel({
    required this.userIdHive,
    required this.nameHive,
    required this.emailHive,
    required this.tokenHive,
    required this.phoneHive,
  }) : super(
    id: userIdHive,
    name: nameHive,
    email: emailHive,
    token: tokenHive,
    phoneNumber: phoneHive
  );


  factory UserModel.fromFireStore(String uid, Map<String, dynamic> json, String token) {
    return UserModel(
      userIdHive: uid,
      nameHive: json["name"] ?? "",
      emailHive: json["email"] ?? "",
      tokenHive: token,
      phoneHive: json["phoneNumber"] ?? "",
    );
  }


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userIdHive: json["id"],
      nameHive: json["name"],
      emailHive: json["email"],
      tokenHive: json["token"],
      phoneHive: json["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "token": token,
    "phoneNumber": phoneHive,
  };


  
}

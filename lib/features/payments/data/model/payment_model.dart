import 'package:hive/hive.dart';
import '../../domain/entities/payment_entity.dart';
part 'payment_model.g.dart';

@HiveType(typeId: 4)
class PaymentModel extends PaymentEntity {
  @HiveField(0) final String idHive;
  @HiveField(1) final String userIdHive;
  @HiveField(2) final double amountHive;
  @HiveField(3) final String noteHive;
  @HiveField(4) final DateTime timestampHive;
  @HiveField(5) final bool syncedHive;
  @HiveField(6) final bool isDeletedHive;

  PaymentModel({
    required this.idHive,
    required this.userIdHive,
    required this.amountHive,
    required this.noteHive,
    required this.timestampHive,
    required this.syncedHive,
    required this.isDeletedHive,
  }) : super(
    id: idHive,
    userId: userIdHive,
    amount: amountHive,
    note: noteHive,
    timestamp: timestampHive,
    synced: syncedHive,
    isDeleted: isDeletedHive,
  );



  Map<String,dynamic> toJson(){
    return {
      "userId": userIdHive,
      "amount": amountHive,
      "note": noteHive,
      "timestamp": timestampHive.toIso8601String(),
      "synced": syncedHive,
    };
  }

  factory PaymentModel.fromJson(Map<String,dynamic> json,String id){
    return PaymentModel(
      idHive: id,
      userIdHive: json["userId"],
      amountHive: json["amount"].toDouble(),
      noteHive: json["note"],
      timestampHive: DateTime.parse(json["timestamp"]),
      syncedHive: json["synced"] ?? false,
      isDeletedHive: json["isDeleted"] ?? false,
    );
  }

  PaymentModel copyWith({
    double? amount,
    String? note,
    bool? synced,
    bool? isDeleted,
  }) {
    return PaymentModel(
      idHive: idHive,
      userIdHive: userIdHive,
      amountHive: amount ?? amountHive,
      noteHive: note ?? noteHive,
      timestampHive: timestampHive,
      syncedHive: synced ?? syncedHive,
      isDeletedHive: isDeleted ?? isDeletedHive,
    );
  }

}

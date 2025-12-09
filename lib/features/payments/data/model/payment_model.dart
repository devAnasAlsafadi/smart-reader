import 'package:hive/hive.dart';
import '../../domain/entities/payment_entity.dart';
part 'payment_model.g.dart';

@HiveType(typeId: 4)
class PaymentModel extends PaymentEntity {
  @HiveField(0) final String idHive;
  @HiveField(1) final String customerIdHive;
  @HiveField(2) final double amountHive;
  @HiveField(3) final String noteHive;
  @HiveField(4) final DateTime timestampHive;
  @HiveField(5) final bool syncedHive;
  @HiveField(6) final bool isDeletedHive;

  PaymentModel({
    required this.idHive,
    required this.customerIdHive,
    required this.amountHive,
    required this.noteHive,
    required this.timestampHive,
    required this.syncedHive,
    required this.isDeletedHive,
  }) : super(
    id: idHive,
    customerId: customerIdHive,
    amount: amountHive,
    note: noteHive,
    timestamp: timestampHive,
    synced: syncedHive,
    isDeleted: isDeletedHive,
  );



  Map<String,dynamic> toJson(){
    return {
      "id": idHive,
      "customerId": customerIdHive,
      "amount": amountHive,
      "note": noteHive,
      "timestamp": timestampHive.toIso8601String(),
      "synced": syncedHive,
      "isDeleted": isDeletedHive,
    };
  }

  factory PaymentModel.fromJson(Map<String,dynamic> json){
    return PaymentModel(
      idHive: json["id"],
      customerIdHive: json["customerId"],
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
      customerIdHive: customerIdHive,
      amountHive: amount ?? amountHive,
      noteHive: note ?? noteHive,
      timestampHive: timestampHive,
      syncedHive: synced ?? syncedHive,
      isDeletedHive: isDeleted ?? isDeletedHive,
    );
  }

}

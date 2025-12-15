// lib/features/meter_reading/data/models/meter_reading_model.dart

import 'package:hive/hive.dart';
import '../../domain/entities/meter_reading_entity.dart';

part 'meter_reading_model.g.dart';


@HiveType(typeId: 3)
class MeterReadingModel extends MeterReadingEntity {
  @HiveField(0) final String idHive;
  @HiveField(1) final String customerIdHive;
  @HiveField(2) final double meterValueHive;
  @HiveField(3) final double consumptionHive;
  @HiveField(4) final double costHive;
  @HiveField(5) final DateTime timestampHive;
  @HiveField(6) final String imagePathHive;
  @HiveField(7) final String? imageUrlHive;
  @HiveField(8) final bool syncedHive;
  @HiveField(9) final bool isDeletedHive;

  MeterReadingModel({
    required this.idHive,
    required this.customerIdHive,
    required this.meterValueHive,
    required this.consumptionHive,
    required this.costHive,
    required this.timestampHive,
    required this.imagePathHive,
    required this.syncedHive,
    required this.isDeletedHive,
    this.imageUrlHive,
  }) : super(
    id: idHive,
    customerId: customerIdHive,
    meterValue: meterValueHive,
    consumption: consumptionHive,
    cost: costHive,
    timestamp: timestampHive,
    imagePath: imagePathHive,
    imageUrl: imageUrlHive,
    synced: syncedHive,
    isDeleted: isDeletedHive,
  );


  Map<String, dynamic> toJson() => {
    'id': idHive,
    'customerId': customerIdHive,
    'meterValue': meterValueHive,
    'consumption': consumptionHive,
    'cost': costHive,
    'timestamp': timestampHive.toIso8601String(),
    'imageUrl': imageUrlHive,
    'synced': syncedHive,
  };

  factory MeterReadingModel.fromJson(Map<String, dynamic> json) {
    return MeterReadingModel(
      idHive: json['id'],
      customerIdHive: json['customerId'],
      meterValueHive: json['meterValue'],
      consumptionHive: json['consumption'],
      costHive: json['cost'],
      timestampHive: DateTime.parse(json['timestamp']),
      imagePathHive: '',
      imageUrlHive: json['imageUrl'],
      syncedHive: json['synced'] ?? false,
      isDeletedHive: json['isDeleted'] ?? false,
    );
  }

  MeterReadingModel copyWith({
    String? imagePathHive,
    String? imageUrlHive,
    bool? syncedHive,
    bool? isDeletedHive,
  }) {
    return MeterReadingModel(
      idHive: idHive,
      customerIdHive: customerIdHive,
      meterValueHive: meterValueHive,
      consumptionHive: consumptionHive,
      costHive: costHive,
      timestampHive: timestampHive,
      imagePathHive: imagePathHive ?? this.imagePathHive,
      imageUrlHive: imageUrlHive ?? this.imageUrlHive,
      syncedHive: syncedHive ?? this.syncedHive, isDeletedHive: isDeletedHive??this.isDeletedHive,
    );
  }
}

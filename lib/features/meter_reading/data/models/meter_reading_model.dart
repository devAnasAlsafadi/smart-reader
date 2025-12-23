// lib/features/meter_reading/data/models/meter_reading_model.dart

import 'package:hive/hive.dart';
import '../../domain/entities/meter_reading_entity.dart';

part 'meter_reading_model.g.dart';


@HiveType(typeId: 3)
class MeterReadingModel extends MeterReadingEntity {

  @HiveField(0) final String idHive;
  @HiveField(1) final String userIdHive;
  @HiveField(2) final double meterValueHive;
  @HiveField(3) final double consumptionHive;
  @HiveField(4) final double costHive;


  @HiveField(5) final double pricePerKwhUsedHive;
  @HiveField(6) final double minMonthlyFeeUsedHive;
  @HiveField(7) final String calculationModeUsedHive;
  @HiveField(8) final int settingsVersionUsedHive;

  @HiveField(9) final DateTime timestampHive;
  @HiveField(10) final String imagePathHive;
  @HiveField(11) final String? imageUrlHive;
  @HiveField(12) final bool syncedHive;
  @HiveField(13) final bool isDeletedHive;


  MeterReadingModel({
    required this.idHive,
    required this.userIdHive,
    required this.meterValueHive,
    required this.consumptionHive,
    required this.costHive,
    required this.timestampHive,
    required this.imagePathHive,
    required this.syncedHive,
    required this.isDeletedHive,
    required this.calculationModeUsedHive,
    required this.minMonthlyFeeUsedHive,
    required this.pricePerKwhUsedHive,
    required this.settingsVersionUsedHive,
    this.imageUrlHive,
  }) : super(
    id: idHive,
    userId: userIdHive,
    meterValue: meterValueHive,
    consumption: consumptionHive,
    cost: costHive,
    timestamp: timestampHive,

    pricePerKwhUsed: pricePerKwhUsedHive,
    minMonthlyFeeUsed: minMonthlyFeeUsedHive,
    calculationModeUsed: calculationModeUsedHive,
    settingsVersionUsed: settingsVersionUsedHive,

    imagePath: imagePathHive,
    imageUrl: imageUrlHive,
    synced: syncedHive,
    isDeleted: isDeletedHive,

  );


  Map<String, dynamic> toJson() =>
      {
        'userId': userIdHive,
        'meterValue': meterValueHive,
        'consumption': consumptionHive,
        'cost': costHive,
        'pricePerKwhUsed': pricePerKwhUsedHive,
        'minMonthlyFeeUsed': minMonthlyFeeUsedHive,
        'calculationModeUsed': calculationModeUsedHive,
        'settingsVersionUsed': settingsVersionUsedHive,
        'timestamp': timestampHive.toIso8601String(),
        'imageUrl': imageUrlHive,
        'synced': syncedHive,
      };

  factory MeterReadingModel.fromJson(Map<String, dynamic> json,String id) {
    return MeterReadingModel(
      idHive: id,
      userIdHive: json['userId'],
      meterValueHive: (json['meterValue'] as num).toDouble(),
      consumptionHive: (json['consumption'] as num).toDouble(),
      costHive: (json['cost'] as num).toDouble(),

      // 🔥 billing snapshot
      pricePerKwhUsedHive: (json['pricePerKwhUsed'] as num).toDouble(),
      minMonthlyFeeUsedHive: (json['minMonthlyFeeUsed'] as num).toDouble(),
      calculationModeUsedHive: json['calculationModeUsed'],
      settingsVersionUsedHive: json['settingsVersionUsed'] as int,

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
      userIdHive: userIdHive,
      meterValueHive: meterValueHive,
      consumptionHive: consumptionHive,
      costHive: costHive,

      pricePerKwhUsedHive: pricePerKwhUsedHive,
      minMonthlyFeeUsedHive: minMonthlyFeeUsedHive,
      calculationModeUsedHive: calculationModeUsedHive,
      settingsVersionUsedHive: settingsVersionUsedHive,

      timestampHive: timestampHive,
      imagePathHive: imagePathHive ?? this.imagePathHive,
      imageUrlHive: imageUrlHive ?? this.imageUrlHive,
      syncedHive: syncedHive ?? this.syncedHive,
      isDeletedHive: isDeletedHive ?? this.isDeletedHive,
    );
  }
}

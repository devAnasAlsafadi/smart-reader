import 'package:hive/hive.dart';
import '../../domain/entities/billing_settings_entity.dart';

part 'billing_settings_model.g.dart';

@HiveType(typeId: 10)
class BillingSettingsModel extends BillingSettingsEntity {

  @HiveField(0)
  final String idHive;

  @HiveField(1)
  final int versionHive;

  @HiveField(2)
  final double pricePerKwhHive;

  @HiveField(3)
  final double minMonthlyFeeHive;

  @HiveField(4)
  final String  calculationModeHive;



  BillingSettingsModel({
    required this.idHive,
    required this.versionHive,
    required this.pricePerKwhHive,
    required this.minMonthlyFeeHive,
    required this.calculationModeHive,
  }) : super(
    id: idHive,
    version: versionHive,
    pricePerKwh: pricePerKwhHive,
    minMonthlyFee: minMonthlyFeeHive,
    calculationMode: calculationModeHive,
  );

  factory BillingSettingsModel.fromJson({
    required String id,
    required Map<String, dynamic> json,
  }) {
    return BillingSettingsModel(
      idHive: id,
      versionHive: json['version'] ?? 1,
      pricePerKwhHive: (json['pricePerKwh'] as num).toDouble(),
      minMonthlyFeeHive: (json['minMonthlyFee'] as num).toDouble(),
      calculationModeHive: json['calculationMode'],
    );
  }

  Map<String, dynamic> toJson() => {
    'version': versionHive,
    'pricePerKwh': pricePerKwhHive,
    'minMonthlyFee': minMonthlyFeeHive,
    'calculationMode': calculationModeHive,
  };
}

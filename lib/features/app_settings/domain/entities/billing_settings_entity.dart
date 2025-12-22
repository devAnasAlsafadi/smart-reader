
class BillingSettingsEntity {
  final String id;
  final int version;
  final double pricePerKwh;
  final double minMonthlyFee;
  final String calculationMode;

  const BillingSettingsEntity({
    required this.id,
    required this.version,
    required this.pricePerKwh,
    required this.minMonthlyFee,
    required this.calculationMode,

  });
}
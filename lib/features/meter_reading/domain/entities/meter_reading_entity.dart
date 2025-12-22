// lib/features/meter_reading/domain/entities/meter_reading_entity.dart


class MeterReadingEntity {
  final String id;
  final String userId;

   double meterValue;
  final double consumption;
  final double cost;


  //  Billing snapshot
  final double pricePerKwhUsed;
  final double minMonthlyFeeUsed;
  final String calculationModeUsed;
  final int settingsVersionUsed;

  final DateTime timestamp;
  final String imagePath;
  final String? imageUrl;
  final bool synced;
  final bool isDeleted;



  MeterReadingEntity({
    required this.id,
    required this.userId,
    required this.meterValue,
    required this.consumption,
    required this.cost,

    required this.pricePerKwhUsed,
    required this.minMonthlyFeeUsed,
    required this.calculationModeUsed,
    required this.settingsVersionUsed,

    required this.timestamp,
    required this.imagePath,
    required this.synced,
    this.imageUrl,
    this.isDeleted = false,
  });

  static final empty = MeterReadingEntity(
    id: '',
    userId: '',
    timestamp: DateTime.fromMillisecondsSinceEpoch(0),
    imagePath: '',
    imageUrl: '',
    synced: false,
    isDeleted: false,
    consumption: 0.0,
    cost: 0.0,
    meterValue: 0.0,
    calculationModeUsed:"",
    minMonthlyFeeUsed: 0.0,
    pricePerKwhUsed: 0.0,
    settingsVersionUsed: 0,


  );

  MeterReadingEntity copyWithNewData({
    String? id,
    String? userId,
    double? meterValue,
    double? cost,
    double? consumption,
    DateTime? timestamp,
    String? imagePath,
    String? imageUrl,
    bool? synced,
    bool? isDeleted,
    double? pricePerKwhUsed,
    double? minMonthlyFeeUsed,
    String? calculationModeUsed,
    int? settingsVersionUsed,
  }) {
    return MeterReadingEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      meterValue: meterValue ?? this.meterValue,
      consumption: consumption ?? this.consumption,
      cost: cost ?? this.cost,
      timestamp: timestamp ?? this.timestamp,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      synced: synced ?? this.synced,
      isDeleted: isDeleted ?? this.isDeleted,
      pricePerKwhUsed: pricePerKwhUsed ?? this.pricePerKwhUsed,
      minMonthlyFeeUsed: minMonthlyFeeUsed ?? this.minMonthlyFeeUsed,
      calculationModeUsed: calculationModeUsed ?? this.calculationModeUsed,
      settingsVersionUsed: settingsVersionUsed ?? this.settingsVersionUsed,

    );
  }
}

// lib/features/meter_reading/domain/entities/meter_reading_entity.dart

class MeterReadingEntity {
  final String id;
  final String customerId;
   double meterValue;
  final double consumption;
  final double cost;


  final DateTime timestamp;
  final String imagePath;
  final String? imageUrl;
  final bool synced;

  final bool isDeleted;



  MeterReadingEntity({
    required this.id,

    required this.customerId,
    required this.meterValue,
    required this.consumption,
    required this.cost,
    required this.timestamp,
    required this.imagePath,
    required this.synced,
    this.imageUrl,
    this.isDeleted = false,
  });

  static final empty = MeterReadingEntity(
    id: '',
    customerId: '',
    timestamp: DateTime.fromMillisecondsSinceEpoch(0),
    imagePath: '',
    imageUrl: '',
    synced: false,
    isDeleted: false,
    consumption: 0.0,
    cost: 0.0,
    meterValue: 0.0

  );

  MeterReadingEntity copyWithNewData({
    String? id,
    String? customerId,
    double? meterValue,
    double? cost,
    double? consumption,
    DateTime? timestamp,
    String? imagePath,
    String? imageUrl,
    bool? synced,
    bool? isDeleted,
  }) {
    return MeterReadingEntity(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      meterValue: meterValue ?? this.meterValue,
      consumption: consumption ?? this.consumption,
      cost: cost ?? this.cost,
      timestamp: timestamp ?? this.timestamp,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      synced: synced ?? this.synced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

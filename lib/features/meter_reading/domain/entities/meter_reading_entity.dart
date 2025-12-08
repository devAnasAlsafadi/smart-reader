// lib/features/meter_reading/domain/entities/meter_reading_entity.dart

class MeterReadingEntity {
  final String id;
  final String customerId;
   String reading;
  final DateTime timestamp;
  final String imagePath;
  final String? imageUrl;
  final bool synced;

  final bool isDeleted;



  MeterReadingEntity({
    required this.id,

    required this.customerId,
    required this.reading,
    required this.timestamp,
    required this.imagePath,
    required this.synced,
    this.imageUrl,
    this.isDeleted = false,
  });

  static final empty = MeterReadingEntity(
    id: '',
    customerId: '',
    reading: '',
    timestamp: DateTime.fromMillisecondsSinceEpoch(0),
    imagePath: '',
    imageUrl: '',
    synced: false,
    isDeleted: false

  );

  MeterReadingEntity copyWithNewData({
    String? id,
    String? customerId,
    String? reading,
    DateTime? timestamp,
    String? imagePath,
    String? imageUrl,
    bool? synced,
    bool? isDeleted,
  }) {
    return MeterReadingEntity(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      reading: reading ?? this.reading,
      timestamp: timestamp ?? this.timestamp,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      synced: synced ?? this.synced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

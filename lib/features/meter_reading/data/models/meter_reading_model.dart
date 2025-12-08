// lib/features/meter_reading/data/models/meter_reading_model.dart

import 'package:hive/hive.dart';
import '../../domain/entities/meter_reading_entity.dart';

part 'meter_reading_model.g.dart';


@HiveType(typeId: 3)
class MeterReadingModel extends MeterReadingEntity {
  @HiveField(0) final String idHive;
  @HiveField(1) final String customerIdHive;
  @HiveField(2) final String readingHive;
  @HiveField(3) final DateTime timestampHive;
  @HiveField(4) final String imagePathHive;
  @HiveField(5) final String? imageUrlHive;
  @HiveField(6) final bool syncedHive;
  @HiveField(7) final bool isDeletedHive;

  MeterReadingModel({
    required this.idHive,
    required this.customerIdHive,
    required this.readingHive,
    required this.timestampHive,
    required this.imagePathHive,
    required this.syncedHive,
    required this.isDeletedHive,
    this.imageUrlHive,
  }) : super(
    id: idHive,
    customerId: customerIdHive,
    reading: readingHive,
    timestamp: timestampHive,
    imagePath: imagePathHive,
    imageUrl: imageUrlHive,
    synced: syncedHive,
    isDeleted: isDeletedHive,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'reading': reading,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'synced': synced,
    };
  }

  factory MeterReadingModel.fromJson(Map<String, dynamic> json) {
    return MeterReadingModel(
      idHive: json['id'],
      customerIdHive: json['customerId'],
      readingHive: json['reading'],
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
      readingHive: readingHive,
      timestampHive: timestampHive,
      imagePathHive: imagePathHive ?? this.imagePathHive,
      imageUrlHive: imageUrlHive ?? this.imageUrlHive,
      syncedHive: syncedHive ?? this.syncedHive, isDeletedHive: isDeletedHive??this.isDeletedHive,
    );
  }
}

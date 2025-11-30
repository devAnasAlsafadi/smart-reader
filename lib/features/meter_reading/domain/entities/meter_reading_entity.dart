import 'package:hive/hive.dart';

part 'meter_reading_entity.g.dart';

@HiveType(typeId: 0)
class MeterReadingEntity {
  @HiveField(0)
  final String reading;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String imagePath;

  MeterReadingEntity({
    required this.reading,
    required this.timestamp,
    required this.imagePath,
  });
}

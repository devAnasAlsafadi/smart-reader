// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_reading_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeterReadingEntityAdapter extends TypeAdapter<MeterReadingEntity> {
  @override
  final int typeId = 0;

  @override
  MeterReadingEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeterReadingEntity(
      reading: fields[0] as String,
      timestamp: fields[1] as DateTime,
      imagePath: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MeterReadingEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.reading)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeterReadingEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

import 'package:hive/hive.dart';
import 'package:smart_reader/features/meter_reading/domain/entities/meter_reading_entity.dart';

class MeterReadingRepository {
 static const String boxName = 'meter_readings';



 Future<Box<MeterReadingEntity>> _openBox()async{
   return await Hive.openBox<MeterReadingEntity>(boxName);
 }

 Future<void> saveReading(MeterReadingEntity reading)async{
   final box = await _openBox();
   await box.add(reading);
 }

 // Future<List<MeterReadingEntity>> getAllReadings()async{
 //   final box = await _openBox();
 //   return box.values.toList();
 // }
 Future<List<MapEntry<dynamic, MeterReadingEntity>>> getAllReadings() async {
   final box = await _openBox();
   return box.toMap().entries.toList();
 }
 //
 // Future<void> deleteReading(int index) async {
 //   final box = await _openBox();
 //   await box.deleteAt(index);
 // }

 Future<void> deleteReading(int key) async {
   final box = await _openBox();
   await box.delete(key);
 }


}
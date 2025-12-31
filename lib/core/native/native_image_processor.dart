import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:smart_reader/core/developer.dart';

class NativeImageProcessor {

  static const MethodChannel _channel = MethodChannel('image_processing_channel');

  static Future<List<Uint8List>> enhanceAndSplit(Uint8List imageBytes) async {
    try {
      // نستدعي الميثود الجديد الذي سيعيد قائمة ByteArrays
      final List<dynamic> result = await _channel.invokeMethod('enhanceImage', imageBytes);
      return result.map((e) => e as Uint8List).toList();
    } catch (e) {
      AppLogger.debug("Native Error: $e");
      return [];
    }
  }
  // static const MethodChannel _channel =
  // MethodChannel('image_processing_channel');
  //
  // static Future<Uint8List> enhance(Uint8List bytes) async {
  //   final result =
  //   await _channel.invokeMethod<Uint8List>('enhanceImage', bytes);
  //
  //   return result ?? bytes;
  // }
}

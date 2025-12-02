import 'dart:typed_data';
import 'package:flutter/services.dart';

class NativeImageProcessor {
  static const MethodChannel _channel =
  MethodChannel('image_processing_channel');

  static Future<Uint8List> enhance(Uint8List bytes) async {
    final result =
    await _channel.invokeMethod<Uint8List>('enhanceImage', bytes);

    return result ?? bytes;
  }
}

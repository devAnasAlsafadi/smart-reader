import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class ImageConverter {
  static Future<File> uint8ListToFile(
      Uint8List bytes, {
        String fileName = "meter_image.png",
      }) async {

    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/$fileName");

    await file.writeAsBytes(bytes);

    return file;
  }
}

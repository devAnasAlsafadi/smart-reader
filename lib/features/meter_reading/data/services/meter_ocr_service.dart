import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:lite_rt_for_flutter/flutter_interpreter.dart';
import 'package:lite_rt_for_flutter/lite_rt_for_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_reader/core/developer.dart';
import 'package:smart_reader/core/utils/app_assets.dart';

class MeterOcrService {
  Interpreter? _interpreter;

  final String alphabet = "0123456789abcdefghijklmnopqrstuvwxyz.";

  Future<void> initModel() async {
    try {

      initLiteRTFlutter();
      _interpreter = await FlutterInterpreter.fromAsset(
          AppAssets.modelTfLite,
        options: InterpreterOptions()..threads = 4,
      );

      AppLogger.info('TFLite Success Loaded (TensorFlow Managed Version)');
    } catch (e) {
      AppLogger.error('TFLite Failed to load model: $e');
    }
  }
  void dispose() {
    _interpreter?.close();
  }

  Future<String> runInference(File imageFile) async {
    try {
      await initModel();
      if (_interpreter == null) return 'model_not_loaded';

      late Uint8List imageBytes;
      try {
        imageBytes = await imageFile.readAsBytes();
      } catch (e) {
        AppLogger.error('Error reading image file: $e');
        return 'file_read_error';
      }

      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return 'invalid_image';


      img.Image grayscaleResized = img.copyResize(
          img.grayscale(image),
          width: 200,
          height: 31,
          interpolation: img.Interpolation.linear
      );

      img.Image finalProcessed = img.contrast(grayscaleResized, contrast: 120);

      var input = Float32List(1 * 31 * 200 * 1);
      int pixelIndex = 0;

      for (int y = 0; y < 31; y++) {
        for (int x = 0; x < 200; x++) {
          var pixel = finalProcessed.getPixel(x, y);
          double luminance = (pixel.r + pixel.g + pixel.b) / 3 / 255.0;
          input[pixelIndex++] = luminance;
        }
      }

      var finalInput = input.reshape([1, 31, 200, 1]);
      var output = List<int>.filled(48, 0).reshape([1, 48]);
      try {
        _interpreter!.run(finalInput, output);
      } catch (e) {
        AppLogger.error('Inference execution failed: $e');
        return 'inference_error';
      }


      String extractedText = "";
      int blankIndex = alphabet.length;
      AppLogger.info('Raw Output Indices: ${output[0]}');

      for (var rawValue in output[0]) {
        int charIndex = (rawValue >> 56).toInt();

        if (charIndex == 0 && rawValue > 0) {
          charIndex = (rawValue >> 48).toInt();
        }


        if (charIndex >= 0 && charIndex < alphabet.length && charIndex != blankIndex) {
          String foundChar = alphabet[charIndex];
          if (foundChar == 'a') {
            extractedText += '.';
          } else {
            extractedText += foundChar;
          }
        }
      }
      AppLogger.info('Extracted Result: $extractedText');
      return extractedText.isEmpty ? 'no_text_found' : extractedText;    }
    catch (e) {
      AppLogger.error('General OCR Error: $e');
      return 'ocr_error_occured';
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final file = File('${(await getTemporaryDirectory()).path}/${path.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

}


/*
Future<String> runInference(File imageFile) async {
    try {
      await initModel();
      if (_interpreter == null) return 'model_not_loaded';

      late Uint8List imageBytes;
      try {
        imageBytes = await imageFile.readAsBytes();
      } catch (e) {
        AppLogger.error('Error reading image file: $e');
        return 'file_read_error';
      }

      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return 'invalid_image';


      img.Image grayscaleResized = img.copyResize(
          img.grayscale(image),
          width: 200,
          height: 31
      );



      var input = Float32List(1 * 31 * 200 * 1);
      int pixelIndex = 0;

      for (int y = 0; y < 31; y++) {
        for (int x = 0; x < 200; x++) {
          var pixel = grayscaleResized.getPixel(x, y);
          double luminance = (pixel.r + pixel.g + pixel.b) / 3 / 255.0;
          input[pixelIndex++] = luminance;
        }
      }

      var finalInput = input.reshape([1, 31, 200, 1]);
      var output = List<int>.filled(48, 0).reshape([1, 48]);
      try {
        _interpreter!.run(finalInput, output);
      } catch (e) {
        AppLogger.error('Inference execution failed: $e');
        return 'inference_error';
      }


      String extractedText = "";
      int blankIndex = alphabet.length;
      int lastCharIndex = -1;
      AppLogger.info('Raw Output Indices: ${output[0]}');

      for (var rawValue in output[0]) {
        int charIndex = (rawValue >> 56).toInt();

        if (charIndex == 0 && rawValue > 0) {
          charIndex = (rawValue >> 48).toInt();
        }


        if (charIndex >= 0 && charIndex < alphabet.length && charIndex != blankIndex) {
          if (charIndex != lastCharIndex) {
            extractedText += alphabet[charIndex];
          }
        }
        lastCharIndex = charIndex;
      }
      AppLogger.info('Extracted Result: $extractedText');
      return extractedText.isEmpty ? 'no_text_found' : extractedText;    }
    catch (e) {
      AppLogger.error('General OCR Error: $e');
      return 'ocr_error_occured';
    }
  }
 */

import 'dart:io';

import 'package:smart_reader/features/meter_reading/data/services/ocr_service.dart';

class ProcessImageUseCase{
  final OcrService _ocrService;
  ProcessImageUseCase(this._ocrService);
  Future<String> call(File imageFile)async {
    return await _ocrService.extractTextFromImage(imageFile);
  }
}
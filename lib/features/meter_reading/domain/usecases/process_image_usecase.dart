import 'dart:io';

import 'package:smart_reader/features/meter_reading/data/services/meter_ocr_service.dart';
import 'package:smart_reader/features/meter_reading/data/services/ocr_service.dart';

class ProcessImageUseCase{
  final MeterOcrService _ocrService;
  ProcessImageUseCase(this._ocrService);

  Future<String> call(File imageFile)async {
    return await _ocrService.runInference(imageFile);
  }
}
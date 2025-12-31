  import 'dart:typed_data';
  import 'dart:ui' as ui;

  import 'package:flutter/material.dart';


  class CameraImageProcessor {
    static Future<Uint8List> cropImageToOverlay({
      required ui.Image original,
      required Rect overlayRect,
      required Size screenSize,
    }) async {
      final imgW = original.width.toDouble();
      final imgH = original.height.toDouble();

      final screenW = screenSize.width;
      final screenH = screenSize.height;

      // حساب النسب المئوية للمستطيل بالنسبة للشاشة
      double leftPercent = overlayRect.left / screenW;
      double topOffset = 0.025;
      double topPercent = (overlayRect.top / screenH) - topOffset;
      // double topPercent = overlayRect.top / screenH;
      // double widthPercent = overlayRect.width / screenW;

      if (topPercent < 0) topPercent = 0;
      double widthPercent = overlayRect.width / screenW;
      double heightPercent = (overlayRect.height / screenH) * 0.9;



      double cropX = leftPercent * imgW;
      double cropY = topPercent * imgH;
      double cropWidth = widthPercent * imgW;
      double cropHeight = heightPercent * imgH;


      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);



      canvas.drawImageRect(
        original,
        Rect.fromLTWH(cropX, cropY, cropWidth, cropHeight),
        Rect.fromLTWH(0, 0, cropWidth, cropHeight),
        Paint()
          ..isAntiAlias = true
          ..filterQuality = ui.FilterQuality.high,
      );

      final croppedImg = await recorder.endRecording().toImage(
          cropWidth.toInt(),
          cropHeight.toInt()
      );

      final bytes = await croppedImg.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    }
  }
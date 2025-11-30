import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';


class CameraImageProcessor {

  static Future<Uint8List> cropImageToOverlay({
    required ui.Image original,
    required Rect overlayRect,
    required Size screenSize,
  })async
  {

    final imgW = original.width.toDouble();
    final imgH = original.height.toDouble();

    final screenW = screenSize.width;
    final screenH = screenSize.height;

    double scale;
    final imgAspect = imgW / imgH;
    final screenAspect = screenW / screenH;


    if (imgAspect > screenAspect) {
      scale = screenW / imgW;
    } else {
      scale = screenH / imgH;
    }

    final displayedW = imgW * scale;
    final displayedH = imgH * scale;

    final offsetX = (screenW - displayedW) / 2;
    final offsetY = (screenH - displayedH) / 2;

    final cropX = (overlayRect.left - offsetX) / scale;
    final cropY = (overlayRect.top - offsetY) / scale;
    final cropWidth = overlayRect.width / scale;
    final cropHeight = overlayRect.height / scale;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImageRect(
      original,
      Rect.fromLTWH(cropX, cropY, cropWidth, cropHeight),
      Rect.fromLTWH(0, 0, cropWidth, cropHeight),
      Paint(),
    );

    final croppedImg = await recorder.endRecording()
        .toImage(cropWidth.toInt(), cropHeight.toInt());

    final bytes = await croppedImg.toByteData(
        format: ui.ImageByteFormat.png);

    return bytes!.buffer.asUint8List();
  }
}
import 'package:flutter/material.dart';

class CameraOverlayPainter extends CustomPainter {
  final Rect overlayRect;

  CameraOverlayPainter(this.overlayRect);

  @override
  void paint(Canvas canvas, Size size) {
    final maskPaint = Paint()..color = Colors.black.withValues(alpha: 0.6);

    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(fullRect),
      Path()..addRect(overlayRect),
    );

    canvas.drawPath(path, maskPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(overlayRect, const Radius.circular(12)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CameraOverlayPainter oldDelegate) {
    return oldDelegate.overlayRect != overlayRect;
  }
}
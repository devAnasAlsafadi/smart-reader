import 'package:flutter/material.dart';
class CameraOverlayPainter extends CustomPainter {
  final Rect overlayRect;
  CameraOverlayPainter(this.overlayRect);



  @override
  void paint(Canvas canvas, Size size) {
    final maskPaint = Paint()..color = Colors.black.withValues(alpha: 0.7);
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(fullRect),
      Path()..addRect(overlayRect),

    );
    canvas.drawPath(path, maskPaint);

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;



    canvas.drawRRect(
        RRect.fromRectAndRadius(overlayRect, const Radius.circular(8)),
        borderPaint
    );

    final laserPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.8)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(overlayRect.left , overlayRect.bottom -5),
      Offset(overlayRect.right, overlayRect.bottom -5),
      laserPaint,
    );
    //
    // final guidePaint = Paint()
    //   ..color = Colors.red.withValues(alpha: 0.6)
    //   ..strokeWidth = 1.2;

    // canvas.drawLine(
    //   Offset(overlayRect.left, overlayRect.center.dy),
    //   Offset(overlayRect.right, overlayRect.center.dy),
    //   guidePaint,
    // );
  }

  @override
  bool shouldRepaint(covariant CameraOverlayPainter oldDelegate) {
    return oldDelegate.overlayRect != overlayRect;
  }
}
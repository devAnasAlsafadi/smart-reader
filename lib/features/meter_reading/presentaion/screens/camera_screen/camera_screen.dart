import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/app_dimens.dart';
import '../../../../../core/routes/navigation_manager.dart';
import '../../../../../core/routes/route_name.dart';
import 'camera_image_processor.dart';
import 'camera_overlay_painter.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeFuture;

  final double overlayWidthFactor = 0.9;
  final double overlayHeightFactor = 0.2;
  final double overlayVerticalPosFactor = 0.35;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeFuture = _controller!.initialize();
    setState(() {});
  }

  Future<void> _capture(Rect overlayRect, Size screenSize) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final file = await _controller!.takePicture();
      final bytes = await file.readAsBytes();
      final uiImage = await decodeImageFromList(bytes);

      final croppedBytes = await CameraImageProcessor.cropImageToOverlay(
        original: uiImage,
        overlayRect: overlayRect,
        screenSize: screenSize,
      );

      final dir = await getApplicationDocumentsDirectory();
      final savedPath =
          "${dir.path}/meter_${DateTime
          .now()
          .millisecondsSinceEpoch}.png";

      final savedFile = File(savedPath);
      await savedFile.writeAsBytes(croppedBytes);
      NavigationManger.navigateTo(
        context,
        RouteNames.preview,
        arguments: savedFile,
      );
    } catch (e) {
      debugPrint("Capture error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final screenW = constraints.maxWidth;
              final screenH = constraints.maxHeight;

              final overlayW = screenW * overlayWidthFactor;
              final overlayH = screenH * overlayHeightFactor;
              final overlayRect = Rect.fromLTWH(
                (screenW - overlayW) / 2,
                screenH * overlayVerticalPosFactor,
                overlayW,
                overlayH,
              );

              return Stack(
                children: [
                  Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: _controller!.value.previewSize!.height,
                        height: _controller!.value.previewSize!.width,
                        child: CameraPreview(_controller!),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: CustomPaint(
                      painter: CameraOverlayPainter(overlayRect),
                    ),
                  ),

                  Positioned(
                    top: AppDimens.paddingLarge,
                    left: AppDimens.paddingLarge,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () =>
                          _capture(overlayRect, Size(screenW, screenH)),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

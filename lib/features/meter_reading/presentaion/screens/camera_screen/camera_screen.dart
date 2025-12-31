// Dart
import 'dart:io';
import 'dart:typed_data';

// Flutter
import 'package:flutter/material.dart';

// Third-party
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_reader/core/developer.dart';

// Core
import 'package:smart_reader/core/native/native_image_processor.dart';
import 'package:smart_reader/core/routes/navigation_manager.dart';
import 'package:smart_reader/core/routes/route_name.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';

// Local
import 'camera_image_processor.dart';
import 'camera_overlay_painter.dart';

class CameraScreen extends StatefulWidget {

  final String userId;
  const CameraScreen({super.key, required this.userId});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeFuture;

  final double overlayVerticalPosFactor = 0.35;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCamera();
      _controller!.initialize();
      if (_controller!.value.isInitialized) {
         _controller!.setFocusMode(FocusMode.auto);
         _controller!.setExposureMode(ExposureMode.auto);
      }
    });

  }


  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = _getBackCamera(cameras);

    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }


  CameraDescription _getBackCamera(List<CameraDescription> cameras) {
    return cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
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

      final List<Uint8List> digitImages = [croppedBytes];


      final dir = await getApplicationDocumentsDirectory();
      final enhancedFile = File("${dir.path}/meter_full_${DateTime.now().millisecondsSinceEpoch}.png");
      await enhancedFile.writeAsBytes(croppedBytes);


      NavigationManger.navigateTo(
        context,
        RouteNames.preview,
        arguments: {
          'imageFile': enhancedFile,
          // 'digitImages': digitImages,
          'userId': widget.userId
        },
      );
    } catch (e) {
      debugPrint("Capture error: $e");
    }
  }




  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }
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

              // final overlayW = screenW * 0.35;
              // final overlayH =overlayW / 6.45;
              final overlayW = screenW * 0.50;
              final overlayH = 60.0;

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
                    child: IgnorePointer(
                      ignoring: true,
                      child: CustomPaint(
                        painter: CameraOverlayPainter(overlayRect),
                      ),
                    ),
                  ),
                  Positioned(
                    top: overlayRect.top - 40,
                    left: 0,
                    right: 0,
                    child: const Center(
                      child: Text(
                        "ضع الأرقام على الخط الأحمر",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppDimens.paddingLarge,
                    right: AppDimens.paddingLarge,
                    child: IconButton(
                      icon: Icon(
                        _controller?.value.flashMode == FlashMode.torch
                            ? Icons.flash_on
                            : Icons.flash_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _controller?.setFlashMode(
                            _controller?.value.flashMode == FlashMode.torch
                                ? FlashMode.off
                                : FlashMode.torch
                        );
                        setState(() {});
                      },
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
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        try {
                          debugPrint('Capture clicked');
                          await _capture(overlayRect, Size(screenW, screenH));
                        } catch (e) {
                          debugPrint("CAPTURE ERROR: $e");
                        }
                      },
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

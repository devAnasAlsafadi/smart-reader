import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        imageQuality: 90,
      );

      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      print("Gallery pick error: $e");
      return null;
    }
  }

  Future<File?> pickFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        imageQuality: 90,
      );

      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      print("Camera pick error: $e");
      return null;
    }
  }


  /// Retrieve lost image on Android when the system kills the activity
  Future<File?> retrieveLostImage() async {
    try {
      final LostDataResponse response = await _picker.retrieveLostData();

      if (response.isEmpty) return null;

      if (response.file != null) {
        return File(response.file!.path);
      }

      return null;
    } catch (e) {
      print("Retrieve lost image error: $e");
      return null;
    }
  }

}

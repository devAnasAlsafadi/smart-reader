import 'package:cloudinary_public/cloudinary_public.dart';

class UploadService {
  final cloudinary = CloudinaryPublic(
    'dhrygxk3j',
    'Meter Readings',    // ← Upload Preset (Unsigned)
    cache: false,
  );

  Future<String> uploadImage(String filePath) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          filePath,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      return response.secureUrl;
    } catch (e) {
      print("Cloudinary upload error: $e");
      throw Exception("Image upload failed");
    }
  }
}

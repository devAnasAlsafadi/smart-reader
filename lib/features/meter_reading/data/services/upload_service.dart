import 'dart:io';
import 'package:http/http.dart' as http;

class UploadService {
  static const String apiUrl = "https://api.upload.io/v2/accounts/{accountId}/uploads/binary";
  static const String apiKey = "YOUR_API_KEY_HERE";

  Future<String> upload(String filePath) async {
    final file = File(filePath);

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(apiUrl),
    );

    request.headers['Authorization'] = "Bearer $apiKey";
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final url = RegExp(r'"fileUrl":"(.*?)"').firstMatch(body)?.group(1);

      if (url != null) return url;
    }

    throw Exception("Image upload failed");
  }
}

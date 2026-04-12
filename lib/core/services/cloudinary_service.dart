import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  static const String cloudName = "YOUR_CLOUD_NAME";
  static const String uploadPreset = "profile_upload";

  static Future<String?> uploadImage(File file) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", url);

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(resBody);
      return data["secure_url"];
    } else {
      throw Exception("Upload failed: $resBody");
    }
  }
}

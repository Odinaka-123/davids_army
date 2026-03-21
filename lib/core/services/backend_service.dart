import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = "https://davidsarmy-production.up.railway.app";

  /// SEND VERIFICATION EMAIL
  static Future<bool> sendVerificationEmail(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/send-verification"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    return response.statusCode == 200;
  }

  /// VERIFY CODE
  static Future<bool> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse("$baseUrl/verify-code"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "code": code}),
    );

    return response.statusCode == 200;
  }

  /// 🔥 ADD THIS (VERY IMPORTANT)
  static Future<bool> isEmailVerified(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/check-verification"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["verified"] == true;
    }

    return false;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = "https://davidsarmy-production.up.railway.app";

  static Future<bool> sendVerificationEmail(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/send-verification"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    return response.statusCode == 200;
  }

  static Future<bool> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse("$baseUrl/verify-code"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "code": code}),
    );

    print("VERIFY RESPONSE: ${response.body}"); // 🔥 DEBUG

    return response.statusCode == 200;
  }

  static Future<bool> isEmailVerified(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/check-verification"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    print("CHECK VERIFIED RESPONSE: ${response.body}"); // 🔥 DEBUG

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["verified"] == true;
    }

    return false;
  }
}

// /lib/services/api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = "http://localhost:8000/api";
  static String appId = "YOUR_AGORA_APP_ID";

  static Future<String> getHostToken(String channel) async {
    final res = await http.get(Uri.parse("$baseUrl/live/token/host/$channel"));
    return jsonDecode(res.body)["token"];
  }

  static Future<String> getViewerToken(String channel) async {
    final res = await http.get(
      Uri.parse("$baseUrl/live/token/viewer/$channel"),
    );
    return jsonDecode(res.body)["token"];
  }
}

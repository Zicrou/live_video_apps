// /lib/services/api.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';

Logger logger = Logger();

class ApiService {
  static String baseUrl = "http://192.168.1.4:8000/api/V1/";
  static String appId = "107a917412fa49a792849522945cbd72";
  static final Dio _dio = Dio();

  Future<dynamic> fetchListLives(String userToken) async {
    // AuthController authController = Get.find<AuthController>();
    // String userToken = "4|xB1f3IkRGBSk4grNYsgKfdXNDBeyz8AWAiFHZoGJ7b761875";
    var body = {"title": "Live from Flutter App"};
    try {
      var response = await _dio.get(
        "http://192.168.1.4:8000/api/V1/lives",
        data: body,
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      logger.i("Response Fetch Lives: ${response}");
      logger.i("Response.statusCode Fetch Lives: ${response.statusCode}");
    } catch (e) {
      throw Exception("Error Store Live: ${e.toString()}");
    } // UserToken
  }

  Future<dynamic> storeLive(String userToken) async {
    // AuthController authController = Get.find<AuthController>();
    // String userToken = "4|xB1f3IkRGBSk4grNYsgKfdXNDBeyz8AWAiFHZoGJ7b761875";
    var body = {"title": "Live from Flutter App"};
    try {
      var response = await _dio.post(
        "http://192.168.1.4:8000/api/V1/lives",
        data: body,
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      logger.i("Response Fetch Lives: ${response}");
      logger.i("Response.statusCode Fetch Lives: ${response.statusCode}");

      // Future.delayed(Duration(seconds: 2), () async {
      //   await fetchListLives(userToken);
      // });
    } catch (e) {
      throw Exception("Error Store Live: ${e.toString()}");
    } // UserToken
  }

  static Future<String> getHostToken(String userToken) async {
    final res = await http.get(
      Uri.parse(
        "$baseUrl/live/token/host/$userToken",
      ), // Update this  URL to reach our LiveToken Backend
    ); //livesToken/{live}/token

    return jsonDecode(res.body)["token"];
  }

  static Future<String> getViewerToken(String channel) async {
    final res = await http.get(
      Uri.parse(
        "$baseUrl/live/token/viewer/$channel",
      ), // Update this  URL to reach our LiveToken Backend
    );
    return jsonDecode(res.body)["token"];
  }
}

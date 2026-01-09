// /lib/services/api.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:live_video_apps/app/data/models/live.dart';
import 'package:logger/web.dart';

Logger logger = Logger();

class ApiServices {
  static String baseUrl = "http://192.168.1.7:8000/api/V1";
  static String appId = "107a917412fa49a792849522945cbd72";
  static final Dio _dio = Dio();

  Future<dynamic> fetchListLives(String userToken) async {
    // AuthController authController = Get.find<AuthController>();
    // String userToken = "4|xB1f3IkRGBSk4grNYsgKfdXNDBeyz8AWAiFHZoGJ7b761875";
    var body = {"title": "Live from Flutter App"};
    try {
      var response = await _dio.get(
        "${baseUrl}/lives",
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      logger.i("Response Fetch Lives: ${response.data}");
      var data = response.data;
      // var listLives = list.map((json) => Live.fromJson(json)).toList();

      // 🔥 THIS is the instantiation
      RxList<Live> lives = <Live>[].obs;

      // final List list = data as List;
      lives.value = (data as List).map((json) => Live.fromJson(json)).toList();
      logger.i("List Lives: ${lives.toString()}");

      return lives;
    } catch (e) {
      throw Exception("Error Store Live: ${e.toString()}");
    } // UserToken
  }

  Future<dynamic> storeLives(String userToken) async {
    // AuthController authController = Get.find<AuthController>();
    // String userToken = "4|xB1f3IkRGBSk4grNYsgKfdXNDBeyz8AWAiFHZoGJ7b761875";
    var body = {"title": "Live from Flutter App"};
    try {
      var response = await _dio.post(
        "${baseUrl}/lives",
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

  Future<dynamic> getLive(String userToken) async {
    // AuthController authController = Get.find<AuthController>();
    // String userToken = "4|xB1f3IkRGBSk4grNYsgKfdXNDBeyz8AWAiFHZoGJ7b761875";
    try {
      var response = await _dio.get(
        "${baseUrl}/getLive",
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
      return response;
    } catch (e) {
      throw Exception("Error Get Live: ${e.toString()}");
    } // UserToken
  }

  Future<dynamic> startLives(String userToken) async {
    // AuthController authController = Get.find<AuthController>();
    // String userToken = "10|A4EkBZGz9nYAkhBPqP3riNqiHbj4ayTDFWCPwZy8b4eb9381";
    var id = await getLive(userToken);
    logger.i("ID LIVE: ${id.data}");
    var live = id.data['id'];
    logger.i("Base URL: ${baseUrl}/lives/${live}/start");
    try {
      var response = await _dio.post(
        "${baseUrl}/lives/${live}/start",
        data: {},
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      logger.i("Response Start Live: ${response}");
      logger.i("Response liveToken Lives: ${response.data['liveToken']}");

      return response;
    } catch (e) {
      throw Exception("Error Store Live: ${e.toString()}");
    } // UserToken
  }

  Future<dynamic> stopLives(String userToken) async {
    // AuthController authController = Get.find<AuthController>();
    // String userToken = "4|xB1f3IkRGBSk4grNYsgKfdXNDBeyz8AWAiFHZoGJ7b761875";
    var id = await getLive(userToken);
    var lives = id.data as List;
    if (lives.isEmpty) {
      throw Exception("No live sessions found");
    }
    var live = lives.first['id']; // Get the first live's ID
    logger.i("ID LIVE: ${live}");
    try {
      var response = await _dio.post(
        "${baseUrl}/lives/${live}/stop",
        data: {},
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      logger.i("Response Stop Lives: ${response}");
      logger.i("Response.statusCode Stop Lives: ${response.statusCode}");

      // Future.delayed(Duration(seconds: 2), () async {
      //   await fetchListLives(userToken);
      // });
    } catch (e) {
      throw Exception("Error Stop Live: ${e.toString()}");
    } // UserToken
  }

  static Future<Map<String, dynamic>> getHostToken(String channel) async {
    logger.i("${baseUrl}/agora/token?channel=$channel&role=host");
    final userToken = "10|A4EkBZGz9nYAkhBPqP3riNqiHbj4ayTDFWCPwZy8b4eb9381";
    try {
      // final res = await _dio.get(
      //   "${baseUrl}/agora/token?channel=$channel&role=host",
      // );
      var res = await _dio.get(
        "${baseUrl}/agora/token?channel=$channel&role=host",
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      logger.i("Response from getHostToken: ${res}");

      var data = res.data;
      logger.i("Token from getHostToken: $data");
      return data;
    } catch (e) {
      logger.e("Error in getHostToken: ${e.toString()}");
      rethrow;
    }

    // http.get(
    //   Uri.parse(
    //     "${baseUrl}/agora/token?channel=$channel&role=host",
    //   ), // Update this  URL to reach our LiveToken Backend
    // ); //livesToken/{live}/token
  }

  static Future<Map<String, dynamic>> getViewerToken(String channel) async {
    // final res = await _dio.get(
    //   "${baseUrl}/agora/token?channel=$channel&role=viewer",
    // );
    logger.i("URL: ${baseUrl}/agora/token?channel=$channel&role=viewer");
    final userToken = "10|A4EkBZGz9nYAkhBPqP3riNqiHbj4ayTDFWCPwZy8b4eb9381";

    try {
      var res = await _dio.get(
        "${baseUrl}/agora/token?channel=$channel&role=viewer",
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      logger.i("Response from getViewerToken: ${res}");

      var data = res.data;
      logger.i(
        "Token from getViewerToken: ${[data['token'], data['channel'], data['uid']]}",
      );
      return data;
    } on Exception catch (e) {
      logger.e("Error in getViewerToken: ${e.toString()}");
      rethrow;
    }
    // final res = await http.get(
    //   Uri.parse(
    //     "${baseUrl}/agora/token?channel=$channel&role=viewer",
    //   ), // Update this  URL to reach our LiveToken Backend
    // );
    // var token = jsonDecode(res.body)["token"];
    // logger.i("Token from getViewerToken: $token");
    // return jsonDecode(res.body)["token"];
  }
}

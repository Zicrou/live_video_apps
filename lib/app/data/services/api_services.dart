import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://13.220.86.245/api";

  static Future<List<dynamic>> getVideos() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/videos"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load videos");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("Failed to load videos: ${e.toString}");
    }
  }
}

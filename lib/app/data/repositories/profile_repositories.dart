import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/core/exceptions/network_exceptions.dart';
import 'package:live_video_apps/app/core/values/endpoints.dart';
import 'package:live_video_apps/app/data/models/comment_info.dart';
import 'package:live_video_apps/app/data/models/profile.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/models/user_info.dart';
import 'package:live_video_apps/app/data/models/user_register.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/providers/api_providers.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ProfileRepositories {
  final dio = Dio();
  final _authProvider = Get.find<AuthProvider>();
  final _apiProvider = Get.find<ApiProvider>();

  Future<dynamic> toggleFollow(String userId) async {
    try {
      final res = await _apiProvider.post('$toggleFollowsEndpoint/$userId', {});
      print(
          'VideosRepositories: Toggle follow response: $res, ${res['following']}');
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> getFollowers(String userId) async {
    try {
      final res = await _apiProvider.get('$followersEndpoint/$userId');
      print('VideosRepositories: Get followers response: $res');
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> getFollowing(String userId) async {
    try {
      final res = await _apiProvider.get('$followingEndpoint/$userId');
      print('VideosRepositories: Get following response: $res');
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> getSuggestions(String userId) async {
    try {
      final res = await _apiProvider.get('$suggestionsEndpoint/$userId');
      print('VideosRepositories: Get suggestions response: $res');
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> getProfile(String userId) async {
    try {
      final response = await _apiProvider.get('$profileEndpoint/$userId');
      print('VideosRepositories: Get profile response: $response');

      print(" //. //. //. ...");
      print(
          "VideosRepositories: Get video from profile response: ${response['videos']}");
      print(" //. //. //. Parsing profile data...");

      var res = Profile.fromJson(response);
      print("Profile data: ${res.toString()}");
      // return res;
    } on BadRequestException {
      rethrow;
    }
  }
}

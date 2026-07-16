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

  // Future<dynamic> getProfile(String userId) async {
  //   try {
  //     final response = await _apiProvider.get('$profileEndpoint/$userId');
  //     print('VideosRepositories: Get profile response: $response');

  //     return;
  //     var res = Profile.fromJson(response);
  //     print("Profile data: ${res.toString()}");
  //     // return res;
  //   } on BadRequestException {
  //     rethrow;
  //   }
  // }

  Future<dynamic> fetchLikedVideos(String userId) async {
    try {
      final response =
          await _apiProvider.get('$profileEndpoint/$userId/liked_videos');
      print("Liked Response Videos from Profile Repositories : ${response}");

      if (response == null) {
        return response;
      }
      print(
        'Liked Fetching Videos response profile repositories: ${response['likes']}',
      );
      print(
        'Liked Fetching Videos response profile repositories until data: ${response['likes'][0]}',
      );

      var resp = VideosInfo.fromJson(response);
      print("Liked Liste des videos ${resp.toString()}");
      print("Liked videos runtime type: ${resp.runtimeType}");
      return resp;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> fetchSavedVideos(String userId) async {
    try {
      final response =
          await _apiProvider.getN('$profileEndpoint/$userId/saved_videos');
      print("Saved Response Videos from Profile Repositories : ${response}");
      if (response == null) {
        return response;
      }

      print(
        'Saved Fetching Videos response video repositories: ${response['data']}',
      );

      var res = VideosInfo.fromJson(response);
      print("Saved Liste des videos ${res.toString()}");
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  // Future<dynamic> fetchSharedVideos() async {
  //   try {
  //     final response = await _apiProvider.get(profileEndpoint);
  //     print("Shared Response Videos from Videos Repositories : ${response}");
  //     if (response == null) {
  //       return response;
  //     }

  //     print(
  //       'Shared Fetching Videos response video repositories: ${response['videos']}',
  //     );

  //     var res = VideosInfo.fromJson(response);
  //     print("Shared Liste des videos ${res.toString()}");
  //     return res;
  //   } on BadRequestException {
  //     rethrow;
  //   }
  // }

  Future<dynamic> fetchMyVideos(String userId) async {
    try {
      final response = await _apiProvider.get(listMyVideosEndpoint);
      print("My Videos Response from Videos Repositories : ${response}");
      if (response == null) {
        return response;
      }

      print(
        'My Videos Fetching Videos response video repositories: ${response['videos']}',
      );

      var res = VideosInfo.fromJson(response);
      print("My Videos Liste des videos ${res.toString()}");
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> getProfile(String userId) async {
    try {
      final res = await _apiProvider.get('$profileEndpoint/$userId');
      // print("VideosRepositories: Get profile response: ${res['videos']}");
      // print("Data type 1: ${res.runtimeType}");
      // print("Data type 2: ${res['videos'].runtimeType}");
      var profileData = Profile.fromJson(res);
      print("Profile data: ${profileData.toString()}");
      return profileData;
    } on BadRequestException {
      rethrow;
    }
  }
}

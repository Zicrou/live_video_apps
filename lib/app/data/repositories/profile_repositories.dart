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
          await _apiProvider.get('$profileEndpoint/$userId');
      print("Liked Response Videos from Profile Repositories : ${response}");

      if (response == null) {
        return response;
      }
       print("Response in fetchLikedVideos repository: $response"); // should print the “bee.mp4” video
      
      print("Videos response in fetchLikedVideos: ${response['videos']}"); // should print the “bee.mp4” video
      
      print("Liked response in fetchLikedVideos: ${response['liked']}");  // should print the “butterfly.mp4” video
      
      print("Saved response in fetchLikedVideos: ${response['saved']}");  // should print the “butterfly.mp4” video
      
      print("Url api in fetchLikedVideos: $profileEndpoint/$userId");

      var responseLiked = VideosInfo.fromJson(response['liked']);
      print("Liked Liste des videos ${responseLiked.toString()})");
      print("Liked videos runtime type: ${responseLiked.runtimeType}");
      return responseLiked;
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
      
      var profileData = Profile.fromJson(res);
      
      print("Profile data: ${profileData.toString()}");
      
      return profileData;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> getProfileLikedVideos(String userId) async {
    try {
      
      final res = await _apiProvider.get('$profileEndpoint/$userId/liked');
      
      print("Response in getProfileLikedVideos repository: $res"); // should print the “bee.mp4” video
      
      
      print("Liked response: ${res}");  // should print the “butterfly.mp4” video
      
      print("Url api: $profileEndpoint/$userId");  // should print the “butterfly.mp4” video
      
      // final likedVideos = (res['liked'] as List? ?? [])
      //   .map((video) => VideosInfo.fromJson(video as Map<String, dynamic>))
      //   .toList();
      var likedVideos = Profile.fromJson(res);

      
      print("Liked videos in profile repositories data: ${likedVideos.toString()}");
      
      return likedVideos;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> getProfileSavedVideos(String userId) async {
    try {
      
      final res = await _apiProvider.get('$profileEndpoint/$userId/saved');
      
      print("Response in getProfileSavedVideos repository: $res"); // should print the “bee.mp4” video
      
      
      print("Saved response: ${res['saved']}");  // should print the “butterfly.mp4” video
      
      print("Url api: $profileEndpoint/$userId/saved");  // should print the “butterfly.mp4” video
      
      final savedVideos = (res['saved'] as List? ?? [])
        .map((video) => VideosInfo.fromJson(video as Map<String, dynamic>))
        .toList();
      
      print("Saved videos in profile repositories data: ${savedVideos.toString()}");
      
      return savedVideos;
    } on BadRequestException {
      rethrow;
    }
  }
}

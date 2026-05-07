import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/core/exceptions/network_exceptions.dart';
import 'package:live_video_apps/app/core/values/endpoints.dart';
import 'package:live_video_apps/app/data/models/comment_info.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/models/user_info.dart';
import 'package:live_video_apps/app/data/models/user_register.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/providers/api_providers.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/utilites/dialogs/generic_dialog.dart';
import 'package:live_video_apps/utilites/dialogs/should_get_connected_dialog.dart'
    show showShouldGetConnectedDialog;
import 'package:logger/logger.dart';

final logger = Logger();

class VideosRepositories {
  final dio = Dio();
  final _authProvider = Get.find<AuthProvider>();
  final _apiProvider = Get.find<ApiProvider>();

  Future<dynamic> fetchVideos() async {
    try {
      final response = await _apiProvider.get(listVideosEndpoint);
      print("Response Videos from Videos Repositories : ${response}");
      if (response == null) {
        return response;
      }

      print(
        'Fetching Videos response video repositories: ${response['videos']}',
      );
      // print("Response.data ${response.data}");
      // print("Data type 1: ${response.runtimeType}");
      // print("Data type 2: ${response['videos'].runtimeType}");

      var res = VideosInfo.fromJson(response);
      print("Liste des videos ${res.toString()}");
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future createVideos(Map<String, dynamic> json) async {
    try {
      logger.i("Json from Repositories: ${json}");
      final res = await _apiProvider.post(createPostsEndpoint, json);
      logger.w('AuthRepositories: Create Video response: $res');
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future toggleLikeDislike(Map<String, dynamic> json) async {
    try {
      print("Json from Repositories: ${json}");
      final res = await _apiProvider.post(toggleLikesDislikesEndpoint, json);
      print("VideosRepositories: Create like response: ${res['message']}");
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future toggleSavedUnsaved(Map<String, dynamic> json) async {
    try {
      logger.i("Json from Repositories: ${json}");
      final res = await _apiProvider.post(toggleSavesUnSavesEndpoint, json);
      logger.w('VideosRepositories: Create toggleSave response: $res');
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<CommentInfo> fetchVideoComments(String videoId) async {
    var video_id = videoId;
    try {
      final response = await _apiProvider.get('$listCommentsEndpoint$video_id');
      print("Response Comments from Videos Repositories : ${response}");
      if (response == null) {
        return response;
      }
      logger.w(
        'Fetching Comment response video repositories: ${response['comments']}',
      );
      // print("Response.data ${response.data}");
      // print("Data type 1: ${response.runtimeType}");
      // print("Data type 2: ${response['videos'].runtimeType}");

      var res = CommentInfo.fromJson(response);
      logger.i("Liste des comments ${res.toString()}");
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> addComment(Map<String, dynamic> json) async {
    try {
      final response = await _apiProvider.post(
          '$addCommentEndpoint${json['video_id']}', json);
      if (response == null) {
        return response;
      }
      logger.w(
        'Fetching Comment response video repositories: ${response['comments']}',
      );

      return response;
    } catch ($e) {
      print($e.toString());
    }
  }

  Future<dynamic> addReply(Map<String, dynamic> json) async {
    try {
      final response = await _apiProvider.post(
          '$addCommentReplyEndpoint${json['parent_id']}', // Validate parent_id in the backend
          json);
      if (response == null) {
        return response;
      }
      logger.w(
        'Response Reply repositories: ${response}',
      );

      return response;
    } catch ($e) {
      print($e.toString());
    }
  }

  Future<dynamic> shareVideos(String id) async {
    try {
      final response = await _apiProvider.post('$baseUrl/videos/$id/share', {});
      if (response == null) {
        return response;
      }
      print(
        'Response Share videos repositories: ${response}',
      );
      return response;
    } catch ($e) {
      print($e.toString());
    }
  }

  Future<dynamic> fetchSearchVideos(String query) async {
    var _query = query;
    try {
      final response = await _apiProvider
          .get('$resultsSearchVideoEndpoint', params: {"q": _query});
      print(
          "Response result videos search from Videos Repositories : ${response['videos'][0]}");
      // print(
      //     "Response result videos search owner from Videos Repositories : ${response['videos'][0]['owner']}");
      if (response == null) {
        return response;
      }

      var res = VideosInfo.fromJson(response);
      print("Liste des videos ${res}");
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

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
      final res = await _apiProvider.get('$baseUrl/profile/$userId');
      print('VideosRepositories: Get profile response: $res');
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> fetchVideosFollowing() async {
    try {
      final response = await _apiProvider.get(listVideosFollowingEndpoint);
      print("Following Response Videos from Videos Repositories : ${response}");
      if (response == null) {
        return response;
      }

      print(
        'Following Fetching Videos response video repositories: ${response['videos']}',
      );

      var res = VideosInfo.fromJson(response);
      print("Following Liste des videos ${res.toString()}");
      return res;
    } on BadRequestException {
      rethrow;
    }
  }
}

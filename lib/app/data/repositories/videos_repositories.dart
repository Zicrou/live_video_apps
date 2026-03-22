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
      logger.w(
        'Fetching Videos response video repositories: ${response['videos']}',
      );
      // print("Response.data ${response.data}");
      // print("Data type 1: ${response.runtimeType}");
      // print("Data type 2: ${response['videos'].runtimeType}");

      var res = VideosInfo.fromJson(response);
      logger.i("Liste des videos ${res}");
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
      logger.i("Json from Repositories: ${json}");
      final res = await _apiProvider.post(toggleLikesDislikesEndpoint, json);
      logger.w('VideosRepositories: Create like response: $res');
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

  // Future<UserRegister> signin(
  //   String name,
  //   String phone,
  //   String password,
  //   String email,
  // ) async {
  //   try {
  //     logger.i(
  //       'Auth Repositories: Sign in with phone => $phone and password => $password, name => $name and email => $email',
  //     );
  //     final response = await _apiProvider.postN(
  //       registerEndPoint,
  //       {'name': name, 'phone': phone, 'password': password, 'email': email},
  //       // options: Options(headers: {'Content-type': 'application/json'}),
  //     );

  //     var userRegister = UserRegister();
  //     userRegister = UserRegister.fromJson((response));

  //     if (userRegister.token == null) {
  //       throw Exception("Registering failed: token is null in response");
  //     }
  //     _authProvider.isAuthenticated = true;
  //     _authProvider.authToken = userRegister.token!;
  //     // logger.i('authToken: ${_authProvider.authToken}');
  //     // logger.i("userRegister from Repositories: ${userRegister.toString()}");
  //     return userRegister;
  //   } on BadRequestException {
  //     rethrow;
  //   }
  // }

  // Future<dynamic> signout() async {
  //   try {
  //     logger.i('Auth Repositories: signing out ${_authProvider.authToken}');
  //     final response = await _apiProvider.post(
  //       signOutEndpoint,
  //       // options: Options(
  //       //   headers: {'Authorization': 'Bearer ${_authProvider.authToken}'},
  //       // ),
  //       {"token": _authProvider.authToken},
  //     );
  //     logger.i("Response from Auth Repositories logout: ${response}");
  //     _authProvider.reset();
  //     print("Auth Repositories: reset authProvider ${_authProvider.authToken}");
  //     if (!_authProvider.isAuthenticated) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } on BadRequestException {
  //     rethrow;
  //   }
  // }

  // Future<List<dynamic>> fetchVentes() async {
  //   try {
  //     logger.i("Auth Repositories: Fetching list of ventes");
  //     final res = await _apiProvider.get(venteListEndpoint);
  //     logger.w('List Ventes response: $res');
  //     return res;
  //   } on BadRequestException {
  //     rethrow;
  //   }
  // }

  // Future<List<dynamic>> fetchVentes() async {
  //   final response = await _authProvider.getVentes(); // Calls provider
  //   if (response.statusCode == 200) {
  //     // Assuming response.body is a JSON array
  //     return response.body;
  //   } else {
  //     throw Exception('Failed to fetch ventes');
  //   }
  // }

  // Future<VenteInfo> listVentes() async {
  //   final response = await _apiProvider.getVentes();
  //   //final ventesResponse = VenteResponse.fromJson(response.data);
  //   return VenteInfo.fromJson(response.data);
  // }
}

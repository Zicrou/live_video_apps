import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/core/exceptions/network_exceptions.dart';
import 'package:live_video_apps/app/core/values/endpoints.dart';
import 'package:live_video_apps/app/data/models/comment_info.dart';

import 'package:live_video_apps/app/data/providers/api_providers.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class CommentsRepository {
  final dio = Dio();
  final _authProvider = Get.find<AuthProvider>();
  final _apiProvider = Get.find<ApiProvider>();

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
          '$addCommentEndpoint', json);
      if (response == null) {
        return response;
      }
      logger.w(
        'Fetching Comment response comment repositories: ${response['comment']}',
      );

      return response;
    } catch ($e) {
      print($e.toString());
    }
  }

  Future<dynamic> addReply(Map<String, dynamic> json) async {
    try {
      final response = await _apiProvider.post(
          '$listAddReplyEndpoint${json['parent_id']}', // Validate parent_id in the backend
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

  Future toggleLikeDislike(Map<String, dynamic> json) async {
    try {
      logger.i("Json from Repositories: ${json}");
      final res = await _apiProvider.post(toggleLikesDislikesCommentEndpoint, json);
      logger.w('CommentsRepositories: Toggle likeUnlike response: $res');
      return res;
    } on BadRequestException {
      rethrow;
    }
  }
}

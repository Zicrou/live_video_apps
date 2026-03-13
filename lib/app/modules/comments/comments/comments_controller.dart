import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:live_video_apps/app/data/models/comment_info.dart';
import 'package:live_video_apps/app/data/models/videoActionState.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/repositories/comments_repository.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';
import 'package:live_video_apps/app/data/services/remote_services.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_preview_screen.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

Logger logger = Logger();

class CommentsController extends GetxController {
  var isLoading = true.obs;
  CommentsRepository _commentsRepository = CommentsRepository();
  var commentList = <CommentInfo>[].obs;
  String? user_id;
  late final videoID;
  VideosController() {
    final authProvider = Get.find<AuthProvider>();
    user_id = authProvider.user?.user?.id;
  }

  @override
  void onInit() {
    super.onInit();
    // videoID = widget.videoId;
    // print("Video from init commentcontroller ${videoID}");
    // getComments(videoId);
  }

  // 💬 COMMENT
  Future<void> addComment(
      String videoId, String comment, String user_id, String parent_id) async {
    var data = {
      'comment': comment,
      'video_id': videoId,
      'user_id': user_id,
      'parent_id': parent_id
    };
    try {
      var response = _commentsRepository.addComment(data);
    } catch (e) {}
  }

  Future<CommentInfo> getComments(String video_id) async {
    try {
      var response = await _commentsRepository.fetchVideoComments(video_id);
      print("Response controller comments ${response.comments}");
      response.comments!.forEach((c) {
        print("User: ${c.user!.name} \n comment: ${c.comment}");
        c.replies?.forEach((r) {
          print(r.user!.name);
          print(r.comment);
        });
      });

      commentList.assignAll([response]);
      print("CommentList ${commentList}");
      var comment = commentList[0].comments;
      comment?.forEach((c) {
        // comment
        // var comment = c.comments;
        // comment!.forEach((c) {
        print("User and comment from commentList");
        print(c.user!.name);
        print(c.comment);
        c.replies?.forEach((r) {
          print(r.user!.name);
          print(r.comment);
        });
        // });
      });
      return response;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to fetch comments');
    }
  }

  Future<void> addReply(
      String videoId, String comment, String user_id, String parent_id) async {
    var data = {
      'comment': comment,
      'video_id': videoId,
      'user_id': user_id,
      'parent_id': parent_id
    };
    try {
      var response = _commentsRepository.addReply(data);
    } catch (e) {}
  }

  String formatCount(int count) {
    if (count >= 1000000) {
      double value = count / 1000000;
      return value % 1 == 0
          ? "${value.toInt()}M"
          : "${value.toStringAsFixed(1)}M";
    } else if (count >= 1000) {
      double value = count / 1000;
      return value % 1 == 0
          ? "${value.toInt()}K"
          : "${value.toStringAsFixed(1)}K";
    }
    return count.toString();
  }
}

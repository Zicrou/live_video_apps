import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:live_video_apps/app/data/models/comment_info.dart';
import 'package:live_video_apps/app/data/models/comments.dart';
import 'package:live_video_apps/app/data/models/videoActionState.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/repositories/comments_repository.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';
import 'package:live_video_apps/app/data/services/remote_services.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/comments/comments/comments_screen.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_preview_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

Logger logger = Logger();

class CommentsController extends GetxController {
  var isLoading = true.obs;
  CommentsRepository _commentsRepository = CommentsRepository();
  var commentList = <CommentInfo>[].obs;
  final comment = TextEditingController();
  final GlobalKey<FormState> createCommmentKeyForm = GlobalKey<FormState>();
  final GlobalKey<FormState> createReplyKeyForm = GlobalKey<FormState>();

  String? user_id;
  String? videoID;
  String? parentID;
  final videosController = Get.find<VideosController>();
  RxBool addOrDeleteCommentSuccess = false.obs;
  CommentsController() {
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

  @override
  void onClose() {
    comment.dispose();
  }

  // 💬 COMMENT
  Future<void> addComment() async {
    if (createCommmentKeyForm.currentState!.validate()) {
      createCommmentKeyForm.currentState!.save();

      var com = comment.text.trim();
      print("Video ID: $videoID, user: $user_id, comment: $com");
      var data = {
        'comment': com,
        'video_id': videoID,
        'user_id': user_id,
        // 'parent_id': parent_id
      };
      try {
        var response = await _commentsRepository.addComment(data);
        print("Response from addComment: $response");
        var commentInfo = await getComments(data['video_id']!);
        // update()
        var videoId = data['video_id'];
        final index = videosController.videosList[0].videos!
            .indexWhere((v) => v.id == videoId);
        if (index != -1) {
          videosController.videosList[0].videos![index].commentCount =
              commentInfo.commentCount!;
        }
        addOrDeleteCommentSuccess.value = true;
        print(
            "addOrDeleteCommentSuccess: ${addOrDeleteCommentSuccess.value}, comment from add comment : ${commentInfo.commentCount}, comment count from video list: ${videosController.videosList[0].videos![index].commentCount}");
      } catch (e) {
        addOrDeleteCommentSuccess.value = false;
        throw Exception("Error adding Comment: ${e.toString()}");
      }
    }
  }

  Future<CommentInfo> getComments(String video_id) async {
    try {
      var response = await _commentsRepository.fetchVideoComments(video_id);
      print("Response controller comments ${response.comments}");
      // response.comments!.forEach((c) {
      //   print("User: ${c.user!.name} \n comment: ${c.comment}");
      //   c.replies?.forEach((r) {
      //     print(r.user!.name);
      //     print(r.comment);
      //   });
      // });

      commentList.assignAll([response]);

      // var comment = commentList[0].comment;
      // print("commentsCount in Controller: ${comment}");
      // comment?.forEach((c) {
      // comment
      // var comment = c.comments;
      // comment!.forEach((c) {
      // print("User and comment from commentList");
      // print(c.user!.name);
      // print(c.comment);

      // c.replies?.forEach((r) {
      //   print(r.user!.name);
      //   print(r.comment);
      // });
      // });
      // });
      return response;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to fetch comments');
    }
  }

  Future<void> addReply(String commentId) async {
    if (createReplyKeyForm.currentState!.validate()) {
      createReplyKeyForm.currentState!.save();

      var com = comment.text.trim();
      print(
          "Video ID: $videoID, user: $user_id, comment: $com, parentId: $commentId");
      var data = {
        'comment': com,
        'video_id': videoID,
        'user_id': user_id,
        'parent_id': commentId
      };

      try {
        var response = _commentsRepository.addReply(data);
        // print(response);
        getComments(data['video_id']!);
      } catch (e) {
        print(e.toString());
      }
    }
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

  Future<void> toggleLike(comment) async {
    try {
      comment.isLiked.value = !comment.isLiked.value!;
      comment.likeCount.value =
          comment.likeCount.value + (comment.isLiked.value ? 1 : -1);
      var json = {
        "comment_id": comment.id,
      };
      var response = _commentsRepository.toggleLikeDislike(json);
      update(); // 🔥 THIS refreshes GetBuilder UI
      // return true;
    } catch (e) {
      // rollback on error
      comment.isLiked.value = !comment.isLiked.value!;
      comment.likeCount.value =
          comment.likeCount.value + (comment.isLiked.value ? 1 : -1);
      throw "${e.toString()}";
    }
  }

  void openReply(String commentId) {
    parentID = commentId;
    update();
  }

  void closeReply() {
    parentID = null;
    update();
  }

  Future<void> deleteComment(dynamic comment) async {
    try {
      var response = await _commentsRepository.deleteComment(comment.id!);
      print("Delete response: $response");
      if (response['message'] == "Comment deleted successfully") {
        // deleteCommentSuccess.value = true;
        update(); // Refresh UI after deletion
        // Refresh comments after deletion
        var commentInfo = await getComments(comment.video_id!);
        var videoId = comment.video_id!;
        final index = videosController.videosList[0].videos!
            .indexWhere((v) => v.id == videoId);
        if (index != -1) {
          videosController.videosList[0].videos![index].commentCount =
              commentInfo.commentCount!;
        }
        addOrDeleteCommentSuccess.value = true;
        print(
            "addOrDeleteCommentSuccess: ${addOrDeleteCommentSuccess.value}, comment from delete comment : ${commentInfo.commentCount}, comment count from video list: ${videosController.videosList[0].videos![index].commentCount}");
      }
    } catch (e) {
      print("Error deleting comment: ${e.toString()}");
      addOrDeleteCommentSuccess.value = false;
      throw Exception("Error deleting Comment: ${e.toString()}");
    }
  }

  Future<void> deleteReply(dynamic reply) async {
    try {
      var response = await _commentsRepository.deleteReply(reply.id!);
      print("Delete response: $response");
      if (response['message'] == "Reply deleted successfully") {
        update(); // Refresh UI after deletion
        // Refresh replys after deletion
        getComments(reply.video_id!);
      }
    } catch (e) {
      print("Error deleting comment: ${e.toString()}");
    }
  }

  Future<void> toggleLikeReplies(reply) async {
    try {
      print("toggleLikeReplies controller");
      reply.isLiked.value = !reply.isLiked.value!;
      reply.likeCount.value =
          reply.likeCount.value + (reply.isLiked.value ? 1 : -1);
      var json = {
        "reply_id": reply.id,
      };
      var response = _commentsRepository.toggleLikeDislikeReplies(json);
      update(); // 🔥 THIS refreshes GetBuilder UI
      // return true;
    } catch (e) {
      // rollback on error
      reply.isLiked.value = !reply.isLiked.value!;
      reply.likeCount.value =
          reply.likeCount.value + (reply.isLiked.value ? 1 : -1);
      throw "${e.toString()}";
    }
  }
}

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/reply.dart';
import 'package:live_video_apps/app/data/models/user.dart';
import 'package:logger/web.dart';

Logger logger = Logger();

class Comments {
  String? id;
  String? comment;
  String? user_id;
  String? video_id;
  String? parent_id;
  User? user;
  RxInt likeCount = 0.obs;
  RxList<Reply>? replies;

  Comments(
      {this.id,
      this.comment,
      this.user_id,
      this.video_id,
      this.parent_id,
      this.user,
      this.replies}); //

  RxBool isLiked = false.obs;

  Comments.fromJson(Map<String, dynamic> json) {
    logger.i("Listing Comment in Video Model: $json");
    id = json['id'];
    comment = json['comment'];
    video_id = json['video_id'];
    parent_id = json['parent_id'];
    user_id = json['user_id'];

    logger.i("Listing User in Video Model: ${json['user']}");

    logger.w("Adding this user ${json['user']} to likes list");
    user = User.fromJson(json['user']);
    logger.i("User: ${user.toString()}");
    if (json['replies'] != null) {
      replies = <Reply>[].obs;
      json['replies'].forEach((r) {
        logger.w("liste replies: $r");
        replies?.add(new Reply.fromJson(r));
      });
    }
    isLiked.value = (json['isLiked'] == 1) ? true : false;
    likeCount.value = json['likes_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['video_id'] = this.video_id;
    return data;
  }

  @override
  String toString() {
    return "User: $user_id, Video: $video_id, Comment: $comment, Reply: ${replies?.map((r) => r.comment).toList()}";
  }
}

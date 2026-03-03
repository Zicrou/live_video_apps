import 'dart:convert';

import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/likes.dart';
import 'dart:io';

import 'package:live_video_apps/app/modules/login/login_screen.dart';

Videos videosFromJson(String str) => Videos.fromJson(json.decode(str));

class Videos {
  String? id;
  String? videoUrl;
  String? caption;
  String? ownerId;
  String? postId;
  String? postType;
  RxList<Likes>? likes;
  // int? likesCount;
  /// UI STATE (GetX)
  RxBool isLiked = false.obs;
  RxBool isSaved = false.obs;
  RxInt likeCount = 0.obs;
  RxInt commentCount = 0.obs;
  RxInt savedCount = 0.obs;

  Videos({
    this.id,
    this.videoUrl,
    this.caption,
    this.ownerId,
    this.postId,
    this.postType,
    this.likes,
  });

  Videos.fromJson(Map<String, dynamic> json) {
    logger.i("Listing Videos in Video Model: $json");
    id = json['id'];
    videoUrl = json['video_url'];
    caption = json['caption'];
    ownerId = json['owner_id'];
    postId = json['post_id'];

    postType = json['post_type'];
    if (json['likes'] != null) {
      logger.i("Listing Likes in Video Model: ${json['likes']}");
      likes = <Likes>[].obs;
      json['likes'].forEach((v) {
        logger.w("Adding this like ${v} to likes list");
        likes!.add(Likes.fromJson(v));
        logger.i("list of likes: ${likes.toString()}");
      });
    }
    likeCount.value = json['likes_count'];
    commentCount.value = json['comments_count'];
    savedCount.value = json['saveds_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video_url'] = this.videoUrl;
    data['caption'] = this.caption;
    data['owner_id'] = this.ownerId;
    data['post_id'] = this.postId;
    data['post_type'] = this.postType;
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "ID: $id, Video_url: $videoUrl, Caption: $caption, Owner_id: $ownerId, Post_id: $postId, Post_type: $postType, Likes: ${likes.toString()}";
  }
}

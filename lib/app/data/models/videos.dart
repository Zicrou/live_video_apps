import 'dart:convert';

import 'package:live_video_apps/app/data/models/user.dart';
import 'package:logger/web.dart';

Logger logger = Logger();

Videos videosFromJson(String str) => Videos.fromJson(json.decode(str));

class Videos {
  String? id;
  String? videoUrl;
  String? caption;
  String? ownerId;
  String? postId;
  String? postType;
  User? owner;
  bool? isLiked;
  bool? isSaved;
  int? likeCount;
  int? commentCount;
  int? savedCount;
  int? sharesCount;
  bool? isFollowing;

  Videos({
    this.id,
    this.videoUrl,
    this.caption,
    this.ownerId,
    this.postId,
    this.postType,
    this.sharesCount,
    this.isFollowing,
    this.owner,
    this.likeCount,
    this.commentCount,
    this.savedCount,
    this.isLiked,
    this.isSaved,
  });

  Videos.fromJson(Map<String, dynamic> json) {
    print("Listing Videos in Video Model: $json");
    id = json['id'];
    videoUrl = json['video_url'];
    caption = json['caption'] ?? "";
    ownerId = json['owner_id'];
    postId = json['post_id'];

    postType = json['post_type'];
    likeCount = json['likes_count'] ?? 0;
    commentCount = json['comments_count'] ?? 0;
    savedCount = json['saveds_count'] ?? 0;
    sharesCount = json['shares_count'] ?? 0;

    isLiked = ((json['isLiked'] ?? json['isliked']) > 0) ? true : false;
    isSaved = ((json['isSaved'] ?? json['issaveds']) > 0) ? true : false;
    isFollowing = json['is_following'] ?? false;

    if (json['owner'] != null) {
      owner = User.fromJson(json['owner']);
    }
  }

  @override
  String toString() {
    // TODO: implement toString
    return "ID: $id, Video_url: $videoUrl, Caption: $caption, Owner_id: $ownerId, Post_id: $postId, Post_type: $postType,sharesCount: $sharesCount, isFollowing: $isFollowing, Owner: ${owner.toString()}, likeCount: $likeCount, commentCount: ${commentCount}, savedCount: $savedCount, isLiked: $isLiked, isSaved: $isSaved";
  }
}

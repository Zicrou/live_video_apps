import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/comments.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class CommentInfo {
  RxList<Comments>? comments = <Comments>[].obs;
  
  RxInt? commentCount;

  CommentInfo({
    required this.comments
  });

  CommentInfo.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = comments;
      json['comments'].forEach((c) {
        logger.w("liste comments CommentInfo: $c");
        comments!.add(new Comments.fromJson(c));
      });
        commentCount?.value = json['commentsCount'];
    }

    // likesCount = json['videos']['likesCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['video'] = this.videos;
    // data['likesCount'] = this.likesCount;
    return data;
  }

  @override
  String toString() {
    return '{comment: $comments}';
  }
}

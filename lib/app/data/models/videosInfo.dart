import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class VideosInfo {
  RxList<Videos>? videos = <Videos>[].obs;
  RxInt? likesCount;
  // RxBool? isLiked;
  // RxBool? isSaved;
  RxInt? saveds_count;
  //  RxInt? likeCount;
  RxInt? commentCount;

  VideosInfo({
    required this.videos,
    this.likesCount,
    // this.isLiked,
    // this.isSaved,
    this.commentCount,
    this.saveds_count,
  });

  VideosInfo.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = videos;
      json['videos'].forEach((v) {
        logger.w("liste videos VideoInfo: $v");
        videos!.add(new Videos.fromJson(v));
        likesCount?.value =
            v['likes_count'] ?? 0; // Ensure likes is handled correctly
        saveds_count?.value = v['saveds_count'] ?? 0;
        // isLiked!.value = v['isLiked'];
        // isSaved!.value = v['isSaved'];
        commentCount?.value = v['comments_count'] ?? 0;
      });
    }

    // likesCount = json['videos']['likesCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video'] = this.videos;
    // data['likesCount'] = this.likesCount;
    return data;
  }

  @override
  String toString() {
    return 'VideosInfo{videos: $videos}';
  }
}

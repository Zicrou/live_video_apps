import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class VideosInfo {
  RxList<Videos> videos = <Videos>[].obs;

  VideosInfo({
    required this.videos,
  });

  VideosInfo.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = videos;
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'videos: ${videos.toString()}';
  }
}

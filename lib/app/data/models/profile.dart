import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:live_video_apps/app/data/models/likes.dart';
import 'package:live_video_apps/app/data/models/user.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';

class Profile {
  User? user;
  int? followersCount;
  int? followingCount;
  int? likesCount;
  List<VideosInfo>? videos;
  List<VideosInfo>? likedVideos;
  List<VideosInfo>? savedVideos;

  Profile(
      {this.user,
      this.followersCount,
      this.followingCount,
      this.likesCount,
      this.videos,
      this.likedVideos,
      this.savedVideos});

  // Profile.fromJson(Map<String, dynamic> json) {}
  Profile.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    // print(" Profile user: ${user.toString()}");
    followersCount = json['followers_count'] ?? 0;
    followingCount = json['following_count'] ?? 0;
    likesCount = json['likes_count'] ?? 0;
    if (json['videos'] != null) {
      videos = <VideosInfo>[];
      json['videos'].forEach((v) {
        print("Adding this video ${v} to videos list");
        videos!.add(new VideosInfo.fromJson(v));
        print("Added this video ${v} to videos list");
      });
    }
    // if (json['liked'] != null) {
    //   likedVideos = <VideosInfo>[];
    //   json['liked'].forEach((v) {
    //     likedVideos!.add(new VideosInfo.fromJson(v));
    //     print("Added this liked video ${v} to liked videos list");
    //   });
    // }
    // if (json['saved'] != null) {
    //   savedVideos = <VideosInfo>[];
    //   json['saved'].forEach((v) {
    //     savedVideos!.add(new VideosInfo.fromJson(v));
    //     print("Added this saved video ${v} to saved videos list");
    //   });
    // }
  }
  @override
  String toString() {
    return 'Profile: {user: $user, followersCount: $followersCount, followingCount: $followingCount, likesCount: $likesCount, videos: ${videos?.toString()}}';
  }
}

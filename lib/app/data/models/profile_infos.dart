import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:live_video_apps/app/data/models/profile.dart';
import 'package:live_video_apps/app/data/models/user.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class ProfileInfos {
  // RxList<Videos> videos = <Videos>[].obs;
  // RxInt? commentCount = 0.obs;
  // User? user;

  Profile? profile;
  ProfileInfos({
    required this.profile,
    // this.user,
    // this.profile,
  });

  ProfileInfos.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      profile = profile ?? Profile();
      // profile!.user = User.fromJson(json['user']);
      Profile.fromJson(json);
    }
  }

  @override
  String toString() {
    return 'profile: ${profile.toString()}';
  }
}

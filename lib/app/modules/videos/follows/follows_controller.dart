import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/providers/api_providers.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';

class FollowsController extends GetxController {
  var isFollowing = false.obs;
  VideosRepositories _videosRepositories = VideosRepositories();

  Future<void> toggleFollow(String userId) async {
    try {
      final res = await _videosRepositories.toggleFollow(userId);

      isFollowing.value = res['following'];
    } catch (e) {
      print(e);
    }
  }
}

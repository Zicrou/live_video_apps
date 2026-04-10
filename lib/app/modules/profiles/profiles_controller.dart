import 'package:get/get.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';

class ProfilesController extends GetxController {
  var isLoading = false.obs;
  VideosRepositories _videosRepositories = VideosRepositories();

  var username = "".obs;
  var avatar = "".obs;

  var followersCount = 0.obs;
  var followingCount = 0.obs;
  var likesCount = 0.obs;

  var videos = [].obs;
  var likedVideos = [].obs;
  var savedVideos = [].obs;

  Future<void> getProfile(String userId) async {
    try {
      isLoading(true);

      final res = await _videosRepositories.getProfile(userId);

      username.value = res['user']['name'];
      avatar.value = res['user']['avatar'] ?? "";

      followersCount.value = res['followers_count'];
      followingCount.value = res['following_count'];
      likesCount.value = res['likes_count'];

      videos.value = res['videos'];
      likedVideos.value = res['liked'];
      savedVideos.value = res['saved'];
    } finally {
      isLoading(false);
    }
  }
}

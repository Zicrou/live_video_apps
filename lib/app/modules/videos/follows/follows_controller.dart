import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/providers/api_providers.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';

class FollowsController extends GetxController {
  var followingMap = <String, bool>{}.obs;
  VideosRepositories _videosRepositories = VideosRepositories();
  var followers = [].obs;
  var following = false.obs;
  var suggestions = [].obs;
  var followersCount = 0.obs;
  var followingCount = 0.obs;

  Future<void> toggleFollow(String userId) async {
    final current = followingMap[userId] ?? false;
    try {
      /// 🔥 Optimistic update (instant UI)
      followingMap[userId] = !current;
      final res = await _videosRepositories.toggleFollow(userId);
      print(
          "Response from toggleFollow in FollowsController: ${res['following']} for userId: $userId");
      followersCount.value = res['followersCount'] ?? followersCount.value;
      followingCount.value = res['followingCount'] ?? followingCount.value;
      following.value = res['following'] ?? following.value;
      // return res;
    } catch (e) {
      print(e);

      /// rollback if API fails
      followingMap[userId] = current;
      // return {'following': current};
    }
  }

  void initFollowing(List videos) {
    for (var video in videos) {
      followingMap[video.ownerId] = video.isFollowing;
    }
  }

  Future<void> getFollowers(String userId) async {
    final res = await _videosRepositories.getFollowers('/followers/$userId');
    followers.value = res;
  }

  Future<void> getFollowing(String userId) async {
    final res = await _videosRepositories.getFollowing('/following/$userId');
    following.value = res;
  }

  Future<void> getSuggestions() async {
    final res = await _videosRepositories.getSuggestions('/suggestions');
    suggestions.value = res;
  }

  String formatCount(int count) {
    if (count >= 1000000) {
      double value = count / 1000000;
      return value % 1 == 0
          ? "${value.toInt()}M"
          : "${value.toStringAsFixed(1)}M";
    } else if (count >= 1000) {
      double value = count / 1000;
      return value % 1 == 0
          ? "${value.toInt()}K"
          : "${value.toStringAsFixed(1)}K";
    }
    return count.toString();
  }

  Future<void> loadCounts(String userId) async {
    final res = await _videosRepositories.getFollowers(userId);

    followersCount.value = res['followersCount'] ?? followersCount.value;
    // followingCount.value = res['followingCount'] ?? followingCount.value;
  }
}

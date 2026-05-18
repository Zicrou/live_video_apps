import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/repositories/profile_repositories.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';

class ProfilesController extends GetxController {
  var isLoading = false.obs;
  VideosRepositories _videosRepositories = VideosRepositories();
  ProfileRepositories _profileRepositories = ProfileRepositories();
  var username = "".obs;
  var avatar = "".obs;

  var followersCount = 0.obs;
  var followingCount = 0.obs;
  var likesCount = 0.obs;

  var videos = [].obs;
  var likedVideos = [].obs;
  var savedVideos = [].obs;
  RxList<Videos> myVideosList = <Videos>[].obs;
  RxList<Videos> likedVideosList = <Videos>[].obs;
  RxList<Videos> savedVideosList = <Videos>[].obs;
  RxList<Videos> sharedVideosList = <Videos>[].obs;

  Future<void> getProfile(String userId) async {
    try {
      isLoading(true);

      final res = await _profileRepositories.getProfile(userId);
      return;
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

  Future<dynamic> myVideos() async {
    try {
      isLoading(true);
      final response = await _videosRepositories.fetchVideosFollowing();
      return myVideosList;
    } catch (e) {
      print("Error fetching videos following: ${e.toString()}");
      throw Exception("Failed to fetch videos");
    } finally {
      isLoading(false);
    }
  }

  Future<RxList<Videos>> likedVideosMethod() async {
    try {
      isLoading(true);
      final response = await _profileRepositories.fetchLikedVideos();
      likedVideosList.clear();
      likedVideosList.assignAll([response]);
      return likedVideosList;
    } catch (e) {
      print("Error fetching liked videos: ${e.toString()}");
      throw Exception("Failed to fetch liked videos");
    } finally {
      isLoading(false);
    }
  }

  Future<RxList<Videos>> savedVideosMethod() async {
    try {
      isLoading(true);
      final response = await _profileRepositories.fetchSavedVideos();
      savedVideosList.clear();
      savedVideosList.assignAll([response]);
      return savedVideosList;
    } catch (e) {
      print("Error fetching saved videos: ${e.toString()}");
      throw Exception("Failed to fetch saved videos");
    } finally {
      isLoading(false);
    }
  }

  Future<RxList<Videos>> sharedVideosMethods() async {
    try {
      isLoading(true);
      final response = await _profileRepositories.fetchSharedVideos();
      sharedVideosList.clear();
      sharedVideosList.assignAll([response]);
      return sharedVideosList;
    } catch (e) {
      print("Error fetching shared videos: ${e.toString()}");
      throw Exception("Failed to fetch shared videos");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("ProfilesController initialized with get profile");
    getProfile("b4bf210c-83b1-4034-86e7-68e710a7f1bd");
  }
}

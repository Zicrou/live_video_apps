import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
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

  var videos = <VideosInfo>[].obs;
  var likedVideos = <VideosInfo>[].obs;
  var savedVideos = <VideosInfo>[].obs;
  final ownerId = "".obs;
  Future<void> getProfile(String userId) async {
    try {
      isLoading(true);

      final res = await _profileRepositories.getProfile(userId);
      print("Profile data in controller: ${res.toString()}");
      username.value = res.user?.name ?? "";
      avatar.value = res.user?.avatar ?? "";
      followersCount.value = res.followersCount ?? 0;
      followingCount.value = res.followingCount ?? 0;
      likesCount.value = res.likesCount ?? 0;
      print("Videos list in profile controller: ${res.videos.toString()}");
      print("Runtimetype: ${res.videos.runtimeType}");
      videos.assignAll(res.videos);
      print(
          "Username: ${username.value}, Avatar: ${avatar.value}, Followers: ${followersCount.value}, Following: ${followingCount.value}, Likes: ${likesCount.value}, Videos: ${videos[0].toString()}");
      return;
    } catch (e) {
      print("Error fetching profile: ${e.toString()}");
      throw Exception("Failed to fetch profile");
    } finally {
      isLoading(false);
    }
  }

  // Future<dynamic> myVideos() async {
  //   try {
  //     isLoading(true);
  //     final response = await _videosRepositories.fetchVideosFollowing();
  //     return myVideosList;
  //   } catch (e) {
  //     print("Error fetching videos following: ${e.toString()}");
  //     throw Exception("Failed to fetch videos");
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> likedVideosMethod(String userId) async {
    try {
      isLoading(true);
      final response = await _profileRepositories
          .fetchLikedVideos("edecc2ae-4eb5-4581-9424-b42e77c40392");
      print("Liked videos response in controller: ${response}");
      print("Response in controller: ${response.toString()}");
      print("response runtime type: ${response.runtimeType}");
      return;
      likedVideos.assign(response);
      print("Liked videos in controller: ${likedVideos}");
      // return likedVideos;
    } catch (e) {
      print("Error fetching liked videos: ${e.toString()}");
      throw Exception("Failed to fetch liked videos");
    } finally {
      isLoading(false);
    }
  }

  Future<RxList<VideosInfo>> savedVideosMethod(String userId) async {
    try {
      isLoading(true);
      final response = await _profileRepositories
          .fetchSavedVideos("edecc2ae-4eb5-4581-9424-b42e77c40392");
      savedVideos.assignAll([response]);
      print("Saved videos in controller: ${savedVideos.toString()}");
      return savedVideos;
    } catch (e) {
      print("Error fetching saved videos: ${e.toString()}");
      throw Exception("Failed to fetch saved videos");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("ProfilesController initialized with get profile");
    // var args = Get.arguments;
    // print("UserId in ProfilesController onInit: ${args}");
    // getProfile(args?["ownerId"] as String);
  }
}

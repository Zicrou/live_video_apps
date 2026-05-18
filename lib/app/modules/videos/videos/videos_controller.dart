import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_video_apps/app/data/models/comment_info.dart';
import 'package:live_video_apps/app/data/models/videoActionState.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';
import 'package:live_video_apps/app/data/services/remote_services.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/comments/comments/comments_controller.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_controller.dart';
import 'package:live_video_apps/app/modules/videos/learn_cloud/video_list_screen.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_preview_screen.dart';
import 'package:live_video_apps/app/routes/routes.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

Logger logger = Logger();

class VideosController extends GetxController {
  var isLoading = true.obs;
  VideosRepositories _videosRepositories = VideosRepositories();
  final authControler = Get.find<AuthController>();
  var videosList = <VideosInfo>[].obs;
  final ImagePicker _picker = ImagePicker();

  VideoPlayerController? previewController;
  Rx<File?> selectedVideo = Rx<File?>(null);
  RxBool previewInitialized = false.obs;
  String? user_id;
  final followsController = Get.find<FollowsController>();
  // VideosController() {
  //   final authProvider = Get.find<AuthProvider>();
  //   user_id = authProvider.user?.user?.id;
  // }
  final RxBool isLiked = false.obs;
  final RxBool isSaved = false.obs;
  final RxInt likeCount = 0.obs;
  RxMap<String, int> commentCountMap = <String, int>{}.obs;
  final RxInt sharesCount = 0.obs;
  final RxInt savedCount = 0.obs;
  RxList<Videos> myVideosList = <Videos>[].obs;
  RxList<Videos> likedVideosList = <Videos>[].obs;
  RxList<Videos> savedVideosList = <Videos>[].obs;
  RxList<Videos> sharedVideosList = <Videos>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
    print("Videos GetCurrentRoute in onInit: ${Get.currentRoute}");
    print(
        "IsAuthenticated in onInit: ${authControler.authProvider.isAuthenticated}");
  }

  // Future<void> checkAuthAndLoad() async {
  //   print("Current route init: ${Get.currentRoute}");
  //   if (authControler.authProvider.isAuthenticated == false) {
  //     Get.toNamed(
  //       Routes.login,
  //       arguments: {"previousRoute": Routes.videosFollowing},
  //     );
  //     return;
  //   }

  //   await fetchVideosFollowing();
  // }

  Future<void> fetchVideos() async {
    try {
      isLoading(true);
      final response = await _videosRepositories.fetchVideos();
      videosList.assignAll([response]);

      followsController.initFollowing(videosList[0].videos.toList());

      print("Videos fetched in controller");
    } catch (e) {
      print("Error fetching videos: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // ❤️ LIKE
  Future<void> toggleLike(videofromScreen) async {
    try {
      videofromScreen.isLiked = !videofromScreen.isLiked!;
      videofromScreen.likeCount =
          videofromScreen.likeCount + (videofromScreen.isLiked ? 1 : -1);
      var json = {
        "video_id": videofromScreen.id,
      };
      var response = await _videosRepositories.toggleLikeDislike(json);
      print("Response from toggle like: ${response}");
      if (response['message'] == "Video liked successfully") {
        isLiked(true);
        print("IsLiked inside toggling ${isLiked.value}");
      } else {
        isLiked(false);
      }
    } catch (e) {
      // rollback on error
      videofromScreen.isLiked = !videofromScreen.isLiked!;
      videofromScreen.likeCount =
          videofromScreen.likeCount + (videofromScreen.isLiked ? 1 : -1);
      isLiked(false);
    } finally {
      // isLoading(false);
    }
  }

  // 💾 SAVE
  Future<void> toggleSave(videofromScreen) async {
    try {
      videofromScreen.isSaved = !videofromScreen.isSaved!;
      videofromScreen.savedCount =
          videofromScreen.savedCount + (videofromScreen.isSaved ? 1 : -1);
      var json = {
        "video_id": videofromScreen.id,
      };
      var response = await _videosRepositories.toggleSavedUnsaved(json);
      if (response['message'] == "Video saved successfully") {
        isSaved(true);
        // savedCount.value = response['savedCount'];
      } else {
        isSaved(false);
        savedCount.value = videofromScreen.savedCount;
      }
    } catch (e) {
      // rollback on error
      videofromScreen.isSaved = !videofromScreen.isSaved!;
      videofromScreen.savedCount =
          videofromScreen.savedCount + (videofromScreen.isSaved ? 1 : -1);
      isSaved(false);
      // savedCount.value = videofromScreen.savedCount;
    }
  }

  // 🔗 SHARE
  Future<void> shareVideo(video) async {
    try {
      // video.sharesCount.value =
      //     video.sharesCount.value + 1;
      var response = await _videosRepositories.shareVideos(video.id);
      if (response['message'] == "Shared") {
        sharesCount.value = response['shares'];

        // Share the video URL using share_plus
        ShareParams(
          text: "🔥Sharing this video\n${video.videoUrl}",
          subject: "Check this video",
        );
      }
    } catch (e) {
      sharesCount.value = video.sharesCount;
      print("share error: ${e.toString()}");
    }
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

  Future<void> fetchVideosFollowing() async {
    try {
      isLoading(true);
      final response = await _videosRepositories.fetchVideosFollowing();
      videosList.clear();
      videosList.assignAll([response]);
      print("Videos following fetched in controller");
    } catch (e) {
      print("Error fetching videos following: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
}

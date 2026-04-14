import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:live_video_apps/app/data/models/comment_info.dart';
import 'package:live_video_apps/app/data/models/videoActionState.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';
import 'package:live_video_apps/app/data/services/remote_services.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/comments/comments/comments_controller.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_controller.dart';
import 'package:live_video_apps/app/modules/videos/learn_cloud/video_list_screen.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_preview_screen.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

Logger logger = Logger();

class VideosController extends GetxController {
  var isLoading = true.obs;
  VideosRepositories _videosRepositories = VideosRepositories();
  // final authProvider = Get.find<AuthProvider>();
  final authControler = Get.find<AuthController>();
  var videosList = <VideosInfo>[].obs;
  RxList<Videos> videos = <Videos>[].obs;
  final ImagePicker _picker = ImagePicker();

  VideoPlayerController? previewController;
  Rx<File?> selectedVideo = Rx<File?>(null);
  RxBool previewInitialized = false.obs;
  String? user_id;
  final followsController = Get.find<FollowsController>();
  VideosController() {
    final authProvider = Get.find<AuthProvider>();
    user_id = authProvider.user?.user?.id;
  }
  final RxBool isLiked = false.obs;
  final RxBool isSaved = false.obs;
  final RxInt likeCount = 0.obs;
  RxMap<String, int> commentCountMap = <String, int>{}.obs;
  // final RxString videoUrl = ''.obs;
  final RxInt sharesCount = 0.obs;
  final RxInt savedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // getComments("9694d240-999b-4dce-b527-3ee9c6c1a426");
    // fetchVideos();
  }

  Future<void> fetchVideos() async {
    isLoading(true);
    try {
      // var videos = await RemoteServices.fetchVentes();
      // final Map<String, dynamic> listVideos = {
      //   // "videos": [
      //   //   {
      //   //     "id": 1,
      //   //     "isLiked": false,
      //   //     "isSaved": false,
      //   //     "likeCount": 0,
      //   //     "commentCount": 0,
      //   //     "url":
      //   //         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      //   //   },
      //   //   {
      //   //     "id": 2,
      //   //     "isLiked": false,
      //   //     "isSaved": false,
      //   //     "likeCount": 0,
      //   //     "commentCount": 0,
      //   //     "url":
      //   //         'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      //   //   },
      //   // ],
      // };
      final response = await _videosRepositories.fetchVideos();
      videosList.assignAll([response]);

      followsController.initFollowing(videosList[0].videos!.toList());
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
      if (response['message'] == "Video liked successfully") {
        isLiked(true);
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
      if (response['message'] == "Video shared successfully") {
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
}

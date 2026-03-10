import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:live_video_apps/app/data/models/videoActionState.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';
import 'package:live_video_apps/app/data/services/remote_services.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_preview_screen.dart';
import 'package:logger/logger.dart';
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
  VideosController() {
    final authProvider = Get.find<AuthProvider>();
    user_id = authProvider.user?.user?.id;
  }
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://your-api.com/api',
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer YOUR_TOKEN',
      },
    ),
  );

  // RxMap<RxInt, VideoActionsState> videoStates =
  //     <RxInt, VideoActionsState>{}.obs;

  // void initVideo(RxInt videoId) {
  //   videoStates[videoId] ??= VideoActionsState(
  //     id: videoId,
  //     isLiked: false.obs,
  //     isSaved: false.obs,
  //     likeCount: 0.obs,
  //     commentCount: 0.obs,
  //     url: ''.obs,
  //   );
  // }

  @override
  void onInit() {
    super.onInit();
    getComments("9694d240-999b-4dce-b527-3ee9c6c1a426");
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
      // videos.assignAll(videosList[0].videos);
      logger.i("Liste videos a partir du controller ${videosList}");
      logger.i("Liste videos a partir du controller ${videosList[0].videos}");
    } catch (e) {
      print("Error fetching videos: $e");
    } finally {
      isLoading(false);
    }
  }

  // ❤️ LIKE
  Future<void> toggleLike(videofromScreen) async {
    try {
      videofromScreen.isLiked.value = !videofromScreen.isLiked.value!;
      videofromScreen.likeCount.value = videofromScreen.likeCount.value +
          (videofromScreen.isLiked.value ? 1 : -1);
      var json = {
        "video_id": videofromScreen.id,
      };
      var response = _videosRepositories.toggleLikeDislike(json);
      // await fetchVideos();
    } catch (e) {
      // rollback on error
      videofromScreen.isLiked.value = !videofromScreen.isLiked.value!;
      videofromScreen.likeCount.value = videofromScreen.likeCount.value +
          (videofromScreen.isLiked.value ? 1 : -1);
    }
  }

  // 💾 SAVE
  Future<void> toggleSave(videofromScreen) async {
    try {
      videofromScreen.isSaved.value = !videofromScreen.isSaved.value!;
      videofromScreen.savedCount.value = videofromScreen.savedCount.value +
          (videofromScreen.isSaved.value ? 1 : -1);
      var json = {
        "video_id": videofromScreen.id,
      };
      var response = _videosRepositories.toggleSavedUnsaved(json);
      // await fetchVideos();
    } catch (e) {
      // rollback on error
      videofromScreen.isSaved.value = !videofromScreen.isSaved.value!;
      videofromScreen.savedCount.value = videofromScreen.savedCount.value +
          (videofromScreen.isSaved.value ? 1 : -1);
    }
  }

  // 💬 COMMENT
  Future<void> addComment(String videoId, String comment, String user_id, String parent_id) async {
    var data = {
      'comment': comment,
      'video_id': videoId,
      'user_id': user_id,
      'parent_id': parent_id
    };
    try {
      var response = _videosRepositories.addComment(data);

      // videoStates[videoId]!.commentCount++;
      // videoStates.refresh();
    } catch (e) {}
  }

  Future<void> getComments(String video_id) async {
    try {
      var response = await _videosRepositories.fetchVideoComments(video_id);
      print(response);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addReply(
      String videoId, String comment, String user_id, String parent_id) async {
    var data = {
      'comment': comment,
      'video_id': videoId,
      'user_id': user_id,
      'parent_id': parent_id
    };
    try {
      var response = _videosRepositories.addReply(data);

      // videoStates[videoId]!.commentCount++;
      // videoStates.refresh();
    } catch (e) {}
  }

  // 🔗 SHARE
  Future<void> shareVideo(videoId) async {
    try {
      await dio.post('/videos/$videoId/share');
    } catch (e) {}
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

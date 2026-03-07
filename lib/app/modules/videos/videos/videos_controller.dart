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
    fetchVideos();
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
  Future<void> toggleLike(videofromScreen, like) async {
    logger.i(
      "Toggling like for video controller ${videofromScreen.id}, ${videofromScreen.videoUrl}, current video: ${videofromScreen.isLiked} ${like}",
    );

    final state = videofromScreen;

    // state.isLiked.value = !state.isLiked.value;
    // state.likeCount.value += state.isLiked.value ? 1 : -1;

    // videoStates.refresh();
    // for (var video in videosList) {
    //   if (video.id == state.id) {
    //     logger.i(
    //       "Controller Found matching video in list: ${video.id}, ${state.id}",
    //     );
    //     video.isLiked.value = !video.isLiked.value!;
    //     video.likeCount.value =
    //         video.likeCount.value + (video.isLiked.value ? 1 : -1);
    //     logger.i(
    //       "Controller State video from Screen: ${state.id}, ${state.id}, isLiked: ${state.isLiked}",
    //     );
    //     logger.i(
    //       "Controller Video in list: ${video.id}, ${video.url}, isLiked: ${video.isLiked}",
    //     );
    //   }
    // }

    try {
      var likeId = null;
      // si isLiked = 1 donc true alors on cree une nouvelle like, video_id et like_id = null
      // si isLike = -1 donc false on supprime la like, video_id et like_id = "like_id"
      videofromScreen.isLiked.value = !videofromScreen.isLiked.value!;
      videofromScreen.likeCount.value = videofromScreen.likeCount.value +
          (videofromScreen.isLiked.value ? 1 : -1);
      // if (videofromScreen.isLiked.value == -1) {
      //   likeId = "";
      // } else {
      //   likeId = null;
      // }
      var json = {
        "video_id": videofromScreen.id,
        "like_id": likeId,
      };
      var response = _videosRepositories.toggleLikeDislike(json);
      // await fetchVideos();
    } catch (e) {
      // rollback on error
      // state.isLiked = !state.isLiked;
      // state.likeCount += state.isLiked ? 1 : -1;
      // videoStates.refresh();
    }
  }

  // 💾 SAVE
  Future<void> toggleSave(videofromScreen) async {
    final state = videofromScreen;

    // state.isSaved.value = !state.isSaved.value;
    // videoStates.refresh();

    // try {
    //   await dio.post('/videos/$videoId/save');
    // } catch (e) {
    //   // state.isSaved.value = !state.isSaved.value;
    //   // videoStates.refresh();
    // }
  }

  // 💬 COMMENT
  Future<void> addComment(String videoId, String text) async {
    try {
      await dio.post('/videos/$videoId/comments', data: {'comment': text});

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
}

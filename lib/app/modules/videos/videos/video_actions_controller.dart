import 'dart:convert';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:live_video_apps/app/data/models/videoActionState.dart';
import 'package:live_video_apps/app/data/services/remote_services.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class VideoActionsController extends GetxController {
  var isLoading = true.obs;

  var videosList = <VideoActionsState>[].obs;

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
      final Map<String, dynamic> listVideos = {
        "videos": [
          {
            "id": 1,
            "isLiked": false,
            "isSaved": false,
            "likeCount": 0,
            "commentCount": 0,
            "url":
                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
          },
          {
            "id": 2,
            "isLiked": false,
            "isSaved": false,
            "likeCount": 0,
            "commentCount": 0,
            "url":
                'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          },
        ],
      };
      var json = jsonEncode(listVideos['videos']);
      logger.i("JSON string of videos: ${json}");
      logger.i("JSON string of videos: ${json[0]}");

      for (var video in listVideos["videos"]) {
        videosList.add(VideoActionsState.fromJson(video));
        logger.i(videosList.toString());
      }

      //videosList.assignAll(listVideos);
    } catch (e) {
      print("Error fetching videos: $e");
    } finally {
      isLoading(false);
    }
  }

  // ❤️ LIKE
  Future<void> toggleLike(VideoActionsState videofromScreen) async {
    logger.i(
      "Toggling like for video ${videofromScreen.id}, ${videofromScreen.url}, current video: ${videofromScreen.isLiked}",
    );

    final state = videofromScreen;
    // videoStates[video.id]!;
    // state.isLiked.value = !state.isLiked.value;
    // state.likeCount.value += state.isLiked.value ? 1 : -1;

    // videoStates.refresh();
    for (var video in videosList) {
      if (video.id == state.id) {
        logger.i(
          "Controller Found matching video in list: ${video.id}, ${state.id}",
        );
        video.isLiked.value = !video.isLiked.value!;
        video.likeCount.value =
            video.likeCount.value + (video.isLiked.value ? 1 : -1);
        logger.i(
          "Controller State video from Screen: ${state.id}, ${state.id}, isLiked: ${state.isLiked}",
        );
        logger.i(
          "Controller Video in list: ${video.id}, ${video.url}, isLiked: ${video.isLiked}",
        );
      }
    }

    // await fetchVideos();

    // try {
    //   await dio.post('/videos/$videoId/like');
    // } catch (e) {
    //   // rollback on error
    //   state.isLiked = !state.isLiked;
    //   state.likeCount += state.isLiked ? 1 : -1;
    //   videoStates.refresh();
    // }
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
  Future<void> addComment(int videoId, String text) async {
    try {
      await dio.post('/videos/$videoId/comments', data: {'comment': text});

      // videoStates[videoId]!.commentCount++;
      // videoStates.refresh();
    } catch (e) {}
  }

  // 🔗 SHARE
  Future<void> shareVideo(int videoId) async {
    try {
      await dio.post('/videos/$videoId/share');
    } catch (e) {}
  }
}

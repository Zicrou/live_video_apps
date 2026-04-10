import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_video_apps/app/core/values/app_colors.dart';
import 'package:live_video_apps/app/data/models/likes.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/repositories/comments_repository.dart';
import 'package:live_video_apps/app/modules/comments/comments/comments_controller.dart';
import 'package:live_video_apps/app/modules/comments/comments/comments_screen.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_button_screen.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_controller.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_controller.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_screen.dart';
import 'package:live_video_apps/app/modules/videos/search/search_videos_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos_features/top_bar_screen.dart';
import 'package:live_video_apps/utilites/dialogs/cannot_share_empty_video_dialog.dart';
import 'package:logger/web.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ...existing code...
final logger = Logger();

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final VideosController _actionsController = Get.put(VideosController());
  final VideoController _video_controller = Get.put(VideoController());
  final CommentsController commentsController = Get.put(CommentsController());
  final List<VideoPlayerController> _controllers = [];
  bool _controllersInitialized = false;
  final followsController = Get.find<FollowsController>();

  @override
  void initState() {
    super.initState();
    _initVideos();
  }

  Future<void> _initVideos() async {
    await _actionsController.fetchVideos();

    final videos = _actionsController.videosList[0].videos!.first;
    // for (final video in videos) {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(videos.videoUrl!),
    );

    // await controller.initialize();
    // controller.setLooping(true);

    // _controllers.add(controller);

    await controller.initialize().then((_) {
      controller.setLooping(true);
      // setState(() {
      _controllers.add(controller);

      // _videoPaths.add(video.videoUrl!); // Add the video path

      // });
    });
    // }

    setState(() {
      _controllersInitialized = true;
    });
  }

  // final List<String> _videoPaths = []; // Local picked videos or network URLs

  @override
  Widget build(BuildContext context) {
    // var videos = _actionsController.videosList[0].videos;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.off(() => VideosScreen());
              break;

            case 1:
              Get.to(() => "ExploreScreen");
              break;

            case 2:
              Get.to(() => VideoScreen());
              break;

            case 3:
              Get.to(() => "InboxScreen");
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box, size: 32),
            label: 'Ajouter',
            // backgroundColor: Colors.black.
          ),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
        ],
      ),
      backgroundColor: Colors.black,

      // backgroundColor: Colors.black,
      // bottomNavigationBar: BottomNavigationBar(),
      body: Obx(() {
        if (_actionsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_actionsController.videosList.isEmpty ||
            _actionsController.videosList[0].videos == null ||
            _actionsController.videosList[0].videos!.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        // if (_actionsController.videosList[0] == null) {
        //   print("No videos");
        //   return const Center(child: CircularProgressIndicator());
        // }
        if (_controllers.isEmpty) {
          print("VideoControllerPlayer.value is empty or is charging...");
          return const Center(child: CircularProgressIndicator());
        }
        var firstVideo = _actionsController.videosList[0].videos!.first;
        print("Videos: ${_actionsController.videosList[0].videos}");
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _actionsController.videosList[0].videos!.length,
          itemBuilder: (context, index) {
            var video = firstVideo;
            final controller = _controllers.first;
            print("Video Id: ${video.id}");
            if (!controller.value.isInitialized) {
              return const Center(child: CircularProgressIndicator());
            }

            return VisibilityDetector(
              key: Key("video-$index"),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0.6) {
                  controller.play();
                } else {
                  controller.pause();
                }
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Following / Explore
                          Row(
                            children: [
                              Text(
                                'Following',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'Explore',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          /// LIVE + SEARCH
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigate to live list screen
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'LIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                  onPressed: () {
                                    Get.to(SearchVideosScreen());
                                  },
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white70,
                                  )),
                              const SizedBox(width: 16),
                              TextButton(
                                onPressed: () {
                                  print("Ok");
                                  Get.offAll(SearchVideosScreen());
                                },
                                child:
                                    const Icon(Icons.search, color: Colors.red),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 🎥 VIDEO
                  Stack(
                    children: [
                      /// 🎥 VIDEO
                      SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: controller.value.size.width,
                            height: controller.value.size.height,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      ),

                      /// ⏱️ PROGRESS BAR (no time)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: VideoProgressIndicator(
                          controller,
                          allowScrubbing: true, // optional (user can seek)
                          colors: VideoProgressColors(
                            playedColor: Colors.white,
                            bufferedColor: Colors.white30,
                            backgroundColor: Colors.white10,
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// ❤️ RIGHT ACTIONS
                  Positioned(
                    right: 12,
                    bottom: 120,
                    child: Builder(
                      builder: (context) {
                        return Obx(() {
                          final state = video;
                          if (state == null) {
                            logger.w(
                              "No state found for video at index $index, id: ${_actionsController.videosList[0].videos![index]}",
                            );
                            return const SizedBox.shrink();
                          }

                          // _actionsController.videosList[0].videos![index].isFollowing.value =
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (state.ownerId != _actionsController.user_id)
                                FollowsButtonScreen(video: state),
                              Text(
                                _actionsController.formatCount(
                                    followsController.followersCount.value),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // ❤️ LIKE
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: _actionsController.isLiked.value
                                      ? Colors.red
                                      : Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  // _actionsController.isLoading(true);

                                  _actionsController.toggleLike(state);
                                },
                              ),
                              Text(
                                _actionsController
                                    .formatCount(state.likeCount!),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // 💬 COMMENT
                              IconButton(
                                icon: const Icon(
                                  Icons.comment,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  // void openComments(videoId) {
                                  print("Video id:: ${video.id}");
                                  Get.bottomSheet(
                                      CommentSheet(videoId: video.id!),
                                      isScrollControlled: true);
                                  // }
                                },
                              ),
                              Text(
                                '${state.commentCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // 💾 SAVE
                              IconButton(
                                icon: Icon(
                                  Icons.bookmark,
                                  color: _actionsController.isSaved.value
                                      ? Colors.yellow
                                      : Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _actionsController.toggleSave(state);

                                  logger.i(
                                    "After toggling save for video at index ${state.id}, ${state.videoUrl}, current state: ${state.isSaved}, savedCount: ${state.savedCount}",
                                  );
                                  if (state.isSaved!) {
                                    logger.i(
                                      "Video at index ${state.id} is now saved.",
                                    );
                                  } else {
                                    logger.i(
                                      "Video at index ${state.id} is now unsaved.",
                                    );
                                  }
                                },
                              ),
                              Text(
                                _actionsController
                                    .formatCount(state.savedCount!),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // 🔗 SHARE
                              IconButton(
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () async {
                                  final videoUrl = state.videoUrl;
                                  if (videoUrl!.isEmpty) {
                                    await showCannotShareEmptyVideoDialog(
                                        context);
                                  } else {
                                    // state.sharesCount = state.sharesCount! + 1;
                                    await SharePlus.instance.share(
                                      ShareParams(
                                        text:
                                            "🔥 Watch this video\n${videoUrl}",
                                        subject: "Check this video",
                                      ),
                                    );
                                    await _actionsController.shareVideo(state);
                                  }
                                  // state.id.value,
                                },
                              ),
                              Text(
                                _actionsController.formatCount(
                                    _actionsController.sharesCount.value),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(height: 10),
                            ],
                          );
                        });
                      },
                    ),
                  ),

                  /// 📝 CAPTION
                  Positioned(
                    left: 12,
                    bottom: 40,
                    right: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${video.owner?.name ?? 'Unknown'}", // Use username from video data, or "Unknown" if null
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "${video.caption}", // Use caption from video data, or empty string if null
                          style: TextStyle(color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const TopBar(),
                ],
              ),
            );
          },
        );
      }),

      /// ➕ ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => {_video_controller.pickVideo()}, //pickVideo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

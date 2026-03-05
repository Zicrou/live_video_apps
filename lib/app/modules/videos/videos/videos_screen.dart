import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_video_apps/app/core/values/app_colors.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';
import 'package:logger/web.dart';
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

  final List<VideoPlayerController> _controllers = [];
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideos();
  }

  Future<void> _initVideos() async {
    await _actionsController.fetchVideos();

    final videos = _actionsController.videosList[0].videos!;
    for (final video in videos) {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl!),
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
    }

    setState(() {
      _controllersInitialized = true;
    });
  }

  // final List<String> _videoPaths = []; // Local picked videos or network URLs

  @override
  Widget build(BuildContext context) {
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
        if (_actionsController.videosList[0] == null) {
          print("No videos");
          return const Center(child: CircularProgressIndicator());
        }
        if (_controllers.isEmpty) {
          print("VideoControllerPlayer.value is empty or is charging...");
          return const Center(child: CircularProgressIndicator());
        }
        print("Videos: ${_actionsController.videosList[0].videos}");
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _actionsController.videosList[0].videos!.length,
          itemBuilder: (context, index) {
            final video = _actionsController.videosList[0].videos![index];
            final controller = _controllers[index];

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
                                  color: Colors.white.withOpacity(0.6),
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
                              const Icon(Icons.search, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

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

                  /// ❤️ RIGHT ACTIONS
                  Positioned(
                    right: 12,
                    bottom: 120,
                    child: Builder(
                      builder: (context) {
                        // _actionsController.fetchVideos();
                        // _videos[index]
                        //     .id, // Should use video ID instead of hardcoded '1'
                        // ); // Initialize state for this video ID

                        return Obx(() {
                          final videos =
                              _actionsController.videosList[0].videos!;

                          final state =
                              video; // Should use video ID instead of hardcoded '1'
                          if (state == null) {
                            logger.w(
                              "No state found for video at index $index, id: ${_actionsController.videosList[0].videos![index]}",
                            );
                            return const SizedBox.shrink();
                          }

                          // actionsController
                          //     .videoStates[index]; // Should use video ID instead of hardcoded '1'
                          // _videoPaths[index];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // ❤️ LIKE
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: state.isLiked.value
                                      ? Colors.red
                                      : Colors.white,

                                  size: 32,
                                ),
                                onPressed: () {
                                  // logger.i(
                                  //   "Toggling like for video at index ${state}, ${state.url.value}, ${state.id.value} current state: ${state.isLiked}",
                                  // );
                                  // _actionsController.toggleLike(state);
                                  // logger.i(
                                  //   "After toggling like for video at index ${state.id.value}, ${state.url.value}, ${state.id.value} current state: ${state.isLiked.value}",
                                  // );
                                  // if (state.isLiked.value) {
                                  //   logger.i(
                                  //     "Video at index ${state.id.value} is now liked. Like count: ${state.likeCount.value}",
                                  //   );
                                  // } else {
                                  //   logger.i(
                                  //     "Video at index ${state.id.value} is now unliked. Like count: ${state.likeCount.value}",
                                  //   );
                                  // }
                                },
                              ),
                              Text(
                                '${state.likeCount.value}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // 💬 COMMENT
                              IconButton(
                                icon: const Icon(
                                  Icons.comment,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  // logger.i(
                                  //   "Toggling like for video at index ${state}, ${state.url.value}, ${state.id.value} current state: ${state.isLiked}",
                                  // );
                                  // _actionsController.toggleLike(state);
                                  // logger.i(
                                  //   "After toggling like for video at index ${state.id.value}, ${state.url.value}, ${state.id.value} current state: ${state.isLiked.value}",
                                  // );
                                  // if (state.isLiked.value) {
                                  //   logger.i(
                                  //     "Video at index ${state.id.value} is now liked. Like count: ${state.likeCount.value}",
                                  //   );
                                  // } else {
                                  //   logger.i(
                                  //     "Video at index ${state.id.value} is now unliked. Like count: ${state.likeCount.value}",
                                  //   );
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

                              const SizedBox(height: 16),

                              // 💾 SAVE
                              IconButton(
                                icon: Icon(
                                  Icons.bookmark,
                                  color: //state.isSaved.value
                                      // ? Colors.yellow
                                      Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _actionsController.toggleSave(state);

                                  // logger.i(
                                  //   "After toggling save for video at index ${state.id.value}, ${state.url.value}, ${state.id.value} current state: ${state.isSaved.value}",
                                  // );
                                  // if (state.isSaved.value) {
                                  //   logger.i(
                                  //     "Video at index ${state.id.value} is now saved.",
                                  //   );
                                  // } else {
                                  //   logger.i(
                                  //     "Video at index ${state.id.value} is now unsaved.",
                                  //   );
                                  // }
                                },
                              ),

                              const SizedBox(height: 16),

                              // 🔗 SHARE
                              IconButton(
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  // actionsController.shareVideo(
                                  // state.id.value,
                                },
                              ),
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
                      children: const [
                        Text(
                          '@username',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'This is my TikTok-style caption 🎬🔥',
                          style: TextStyle(color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const _TopBar(),
                ],
              ),
            );
            // return Stack(
            //   children: [
            //     /// VIDEO
            //     VideoPlayer(_controllers[index]),

            //     //  RIGHT ACTIONS
            //     // Positioned(
            //     //   right: 12,
            //     //   bottom: 120,
            //     //   child: _RightActions(video: ),
            //     // ),

            //     /// CAPTION
            //     Positioned(
            //       left: 12,
            //       bottom: 40,
            //       child: Text(
            //         video.caption!,
            //         style: const TextStyle(color: Colors.white),
            //       ),
            //     ),
            //   ],
            // );
          },
        );
      }),
    );
  }
}
// class VideosScreen extends StatelessWidget {

// }

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),

          /// 🔝 TOP BAR (STATIC)
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
              children: const [
                Text('Following', style: TextStyle(color: Colors.white54)),
                SizedBox(width: 16),
                Text(
                  'Explore',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            /// Live + Search
            Row(
              children: [
                Container(
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
                const SizedBox(width: 16),
                const Icon(Icons.search, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RightActions extends StatelessWidget {
  final Videos video;
  const _RightActions({required this.video});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideosController>();

    return Column(
      children: [
        Obx(
          () => IconButton(
            icon: Icon(
              Icons.favorite,
              color: video.isLiked.value ? Colors.red : Colors.white,
              size: 32,
            ),
            onPressed: () => controller.toggleLike(video),
          ),
        ),
        Obx(
          () => Text(
            '${video.likeCount.value}',
            style: const TextStyle(color: Colors.white),
          ),
        ),

        const SizedBox(height: 16),

        IconButton(
          icon: const Icon(Icons.bookmark, color: Colors.white),
          onPressed: () => controller.toggleSave(video),
        ),

        const SizedBox(height: 16),

        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () => controller.shareVideo(video.id),
        ),
      ],
    );
  }
}

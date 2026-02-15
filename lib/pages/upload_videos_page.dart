import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/core/interceptors/api_interceptors.dart';
import 'package:live_video_apps/app/core/values/endpoints.dart';
import 'package:live_video_apps/app/data/models/videoActionState.dart';
import 'package:live_video_apps/app/modules/videos/videos/video_actions_controller.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

Logger logger = Logger();

class UploadVideosPage extends StatefulWidget {
  const UploadVideosPage({super.key});
  @override
  State<UploadVideosPage> createState() => _UploadVideosPageState();
}

class _UploadVideosPageState extends State<UploadVideosPage> {
  final _actionsController = Get.find<VideoActionsController>();
  final List<VideoPlayerController> _controllers = [];
  final List<String> _videoPaths = []; // Local picked videos or network URLs
  final RxList<VideoActionsState> _videos = <VideoActionsState>[].obs;
  final ImagePicker _picker = ImagePicker();
  final baseUrl = 'http://192.168.1.8:8000/api/V1';
  // late VideoActionsState videoState;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  // Pick a video from gallery
  Future<void> pickVideo() async {
    final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked == null) return;

    final controller = VideoPlayerController.file(File(picked.path));
    logger.i('Picked video path: ${picked.path}');

    await controller.initialize();
    controller.setLooping(true);

    setState(() {
      _controllers.add(controller);
      _videoPaths.add(picked.path);
    });
  }

  // Example network videos
  Future<void> addSampleNetworkVideos() async {
    logger.i(
      'Fetched video from API: ${_actionsController.videosList.length} videos',
    );
    final urls = _actionsController.videosList.value.obs;
    for (var video in urls) {
      logger.i(
        'Fetched video from API: ${video.url}, id: ${video.id}, isLiked: ${video.isLiked}, likeCount: ${video.likeCount}',
      );
    }

    // final urls = [
    //   'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    // ];

    var listVideos = await _actionsController.videosList;
    for (var video in listVideos) {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(video.url.value),
      );
      await controller.initialize().then((_) {
        controller.setLooping(true);
        setState(() {});
      });
      _controllers.add(controller);
      _videoPaths.add(video.url.value);
      _videos.add(video);
    }
  }

  @override
  void initState() {
    super.initState();
    addSampleNetworkVideos();
  }

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
          // handle navigation
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
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
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
                      _actionsController.fetchVideos();
                      // _videos[index]
                      //     .id, // Should use video ID instead of hardcoded '1'
                      // ); // Initialize state for this video ID

                      return Obx(() {
                        // final state = actionsController.videoStates[videoId]!;

                        final state =
                            _videos[index]; // Should use video ID instead of hardcoded '1'
                        if (state == null) {
                          logger.w(
                            "No state found for video at index $index, id: ${_actionsController.videosList[index].id}",
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
                                logger.i(
                                  "Toggling like for video at index ${state}, ${state.url.value}, ${state.id.value} current state: ${state.isLiked}",
                                );
                                _actionsController.toggleLike(state);
                                logger.i(
                                  "After toggling like for video at index ${state.id.value}, ${state.url.value}, ${state.id.value} current state: ${state.isLiked.value}",
                                );
                                if (state.isLiked.value) {
                                  logger.i(
                                    "Video at index ${state.id.value} is now liked. Like count: ${state.likeCount.value}",
                                  );
                                } else {
                                  logger.i(
                                    "Video at index ${state.id.value} is now unliked. Like count: ${state.likeCount.value}",
                                  );
                                }
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
                                logger.i(
                                  "Toggling like for video at index ${state}, ${state.url.value}, ${state.id.value} current state: ${state.isLiked}",
                                );
                                _actionsController.toggleLike(state);
                                logger.i(
                                  "After toggling like for video at index ${state.id.value}, ${state.url.value}, ${state.id.value} current state: ${state.isLiked.value}",
                                );
                                if (state.isLiked.value) {
                                  logger.i(
                                    "Video at index ${state.id.value} is now liked. Like count: ${state.likeCount.value}",
                                  );
                                } else {
                                  logger.i(
                                    "Video at index ${state.id.value} is now unliked. Like count: ${state.likeCount.value}",
                                  );
                                }
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

                                logger.i(
                                  "After toggling save for video at index ${state.id.value}, ${state.url.value}, ${state.id.value} current state: ${state.isSaved.value}",
                                );
                                if (state.isSaved.value) {
                                  logger.i(
                                    "Video at index ${state.id.value} is now saved.",
                                  );
                                } else {
                                  logger.i(
                                    "Video at index ${state.id.value} is now unsaved.",
                                  );
                                }
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
                              onPressed: () =>
                                  _actionsController.shareVideo(state.id.value),
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
        },
      ),

      /// ➕ ADD BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: pickVideo,
        child: const Icon(Icons.add),
      ),
    );
  }
}

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

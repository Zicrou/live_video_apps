import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/modules/comments/comments/comments_screen.dart';
import 'package:live_video_apps/app/modules/videos/search/search_videos_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/video_item_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart'
    hide logger;
import 'package:live_video_apps/app/modules/videos/videos_features/top_bar_screen.dart';
import 'package:live_video_apps/app/routes/routes.dart';
import 'package:live_video_apps/app/utils/messages.dart';
import 'package:live_video_apps/utilites/dialogs/cannot_share_empty_video_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class SearchVideosScreen extends StatefulWidget {
  const SearchVideosScreen({super.key});

  @override
  State<SearchVideosScreen> createState() => _SearchVideosScreenState();
}

class _SearchVideosScreenState extends State<SearchVideosScreen> {
  final controller = Get.put(SearchVideosController());

  final List<VideoPlayerController> _controllers = [];
  RxBool _controllersInitialized = false.obs;
  RxBool isTyping = false.obs;
  RxBool isSearching = false.obs;

  Future<void> _initVideos(List videos) async {
    _controllers.clear(); // VERY IMPORTANT

    for (final video in videos) {
      final ctrl = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl!),
      );

      await ctrl.initialize();
      ctrl.setLooping(true);
      ctrl.pause(); // 👈 show first frame only

      _controllers.add(ctrl);
    }

    // setState(() {
    _controllersInitialized.value = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 24, left: 8),
            child: Form(
              key: controller.createSeachKeyForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    // visible: 1 > 0,
                    child: TextFormField(
                      controller: controller.searchTextController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.label,
                          color: Color.fromARGB(255, 0, 173, 253),
                        ),
                        hintText: "Search videos, users...",
                        hintStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            print(
                                "Search for ${controller.searchTextController.text.trim()}");
                            final query =
                                controller.searchTextController.text.trim();
                            if (query.isEmpty) {
                              errorMessage("Veuillez remplir ce champs svp!");
                            }

                            //Search method
                            controller.search();
                          },
                        ),
                      ),
                      onChanged: (value) {
                        controller.searchTextController.text = value;
                        isTyping.value = value.isNotEmpty;
                        isSearching.value = false; // 👈 NOT searching yet
                        controller.search();
                        print("Searching on Change value");
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.results.isEmpty) {
          return const Text("Nothing searched yet");
        }
        final videos = controller.results[0].videos;

        // if (_controllers.length != videos.length) {
        //   _controllersInitialized.value = false;
        // }

        // if (!_controllersInitialized.value) {
        //   Future.microtask(() => _initVideos(videos));
        //   return const Center(child: CircularProgressIndicator());
        // }

        /// 🔍 STEP 1: USER IS TYPING → SHOW SUGGESTIONS
        if (isTyping.value) {
          return ListView.builder(
            itemCount: controller.results[0].videos.length,
            itemBuilder: (context, index) {
              final video = controller.results[0].videos[index];
              print("Caption length: ${controller.captions.length}");
              return ListTile(
                leading: const Icon(Icons.search, color: Colors.black),
                title: Text(video.caption),
                onTap: () {
                  controller.searchTextController.text = video.caption;

                  isTyping.value = false;
                  isSearching.value = true;

                  controller.search(); // 🔥 load videos
                },
              );
            },
          );
        }

        /// 🎥 STEP 2: USER CLICKED SEARCH → SHOW GRID
        if (isSearching.value && controller.results.isNotEmpty) {
          // final videos = controller.results[0].videos!;

          if (_controllers.length != videos.length) {
            _controllersInitialized.value = false;
          }

          if (!_controllersInitialized.value) {
            Future.microtask(() => _initVideos(videos));
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // mainAxisExtent: 300, // 🔥 control height directly
                // crossAxisSpacing: 4,
                // mainAxisSpacing: 4,
                childAspectRatio: 3 / 3),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final item = videos[index];
              final controllerVideo = _controllers[index];

              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => FullVideoScreen(video: item),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  color: Colors.black,
                  child: Stack(
                    children: [
                      /// 🎥 FIRST FRAME
                      _controllers[index].value.isInitialized
                          ? SizedBox.expand(
                              child: AspectRatio(
                                aspectRatio: 3 / 3, // 🔥 force TikTok ratio
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: VideoPlayer(_controllers[index]),
                                ),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),

                      /// 📝 CAPTION
                      Positioned(
                        left: 8,
                        right: 8,
                        bottom: 30,
                        child: Text(
                          item.caption ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),

                      /// ▶️ PLAY ICON
                      const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white70,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        /// 💤 DEFAULT STATE
        return const Center(
          child: Text("Start typing to search"),
        );
      }),
    );
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }
}

class FullVideoScreen extends StatefulWidget {
  final dynamic video;

  const FullVideoScreen({super.key, required this.video});

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  late VideoPlayerController _controller;
  bool isInitialized = false;
  final VideosController _actionsController = Get.find<VideosController>();

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  Future<void> initVideo() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.videoUrl),
    );

    await _controller.initialize();
    _controller.setLooping(true);
    _controller.play(); // 🔥 autoplay

    setState(() {
      isInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ⏯️ Tap to pause/play
  void togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Get.to(VideosScreen());
      // Get.to(VideosScreen());
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        title: TopBar(),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          togglePlay(); // your existing logic

          if (isInitialized) {
            Get.toNamed(
              Routes.videoItem,
              arguments: {
                'video': widget.video,
                'isActive': true,
              },
            );
          }
        },
        child: Center(
          child: isInitialized
              ? const Icon(Icons.play_arrow) // or your UI
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

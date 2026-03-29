import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/modules/comments/comments/comments_screen.dart';
import 'package:live_video_apps/app/modules/videos/search/search_videos_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart'
    hide logger;
import 'package:live_video_apps/app/modules/videos/videos_features/top_bar_screen.dart';
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
                childAspectRatio: 3 / 4),
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
                                aspectRatio: 3 / 4, // 🔥 force TikTok ratio
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
  final VideosController _actionsController = Get.put(VideosController());

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
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: togglePlay,
        child: Center(
          child: isInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    /// 🎥 VIDEO
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),

                    /// ▶️ Pause icon
                    if (!_controller.value.isPlaying)
                      const Icon(
                        Icons.play_arrow,
                        color: Colors.white70,
                        size: 80,
                      ),

                    /// ⏱️ PROGRESS BAR (no time)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true, // optional (user can seek)
                        colors: VideoProgressColors(
                          playedColor: Colors.white,
                          bufferedColor: Colors.white30,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                    ),

                    /// ❤️ RIGHT ACTIONS
                    Positioned(
                      right: 12,
                      bottom: 120,
                      child: Builder(
                        builder: (context) {
                          return Obx(() {
                            final state = widget.video;
                            if (state == null) {
                              logger.w(
                                "No state found for video",
                              );
                              return const SizedBox.shrink();
                            }

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
                                    // var likes = state.likes;
                                    // var like;
                                    // like = likes!
                                    //     .where((like) =>
                                    //         like.userId ==
                                    //         _actionsController.user_id)
                                    //     .first;
                                    // Je veux avoir un smartPhone pour tester mes apps sans vendre mon Iphone,
                                    // avoir un boulot pour me permettra de le faire,
                                    // Un soutien, une connaissance mais qui? Abou s'il en a d'abord?                                   print("like ${like}");

                                    _actionsController.toggleLike(state);
                                  },
                                ),
                                Text(
                                  _actionsController
                                      .formatCount(state.likeCount.value),
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
                                    // void openComments(videoId) {
                                    print("Video id:: ${widget.video.id}");
                                    Get.bottomSheet(
                                        CommentSheet(videoId: widget.video.id!),
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

                                const SizedBox(height: 16),

                                // 💾 SAVE
                                IconButton(
                                  icon: Icon(
                                    Icons.bookmark,
                                    color: state.isSaved.value
                                        ? Colors.yellow
                                        : Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    _actionsController.toggleSave(state);

                                    logger.i(
                                      "After toggling save for video at index ${state.id}, ${state.videoUrl}, current state: ${state.isSaved.value}",
                                    );
                                    if (state.isSaved.value) {
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
                                      .formatCount(state.savedCount.value),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(height: 16),

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
                                      state.sharesCount.value =
                                          state.sharesCount.value + 1;
                                      await SharePlus.instance.share(
                                        ShareParams(
                                          text:
                                              "🔥 Watch this video\n${videoUrl}",
                                          subject: "Check this video",
                                        ),
                                      );
                                      await _actionsController
                                          .shareVideo(state);
                                    }
                                    // state.id.value,
                                  },
                                ),
                                Text(
                                  _actionsController
                                      .formatCount(state.sharesCount.value),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(height: 16),
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
                        // video = widget.video;
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.video.owner.name}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "${widget.video.caption}",
                            style: TextStyle(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const TopBar(),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

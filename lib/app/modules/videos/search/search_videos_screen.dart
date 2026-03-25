import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/modules/videos/search/search_videos_controller.dart';
import 'package:live_video_apps/app/utils/messages.dart';
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Form(
          key: controller.createSeachKeyForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                // visible: venteController.selectedProduit.value == null,
                child: TextFormField(
                  controller: controller.searchTextController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.label,
                      color: Color.fromARGB(255, 0, 173, 253),
                    ),
                    hintText: "Search videos, users...",
                    hintStyle: TextStyle(color: Colors.white54),
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
                        if (controller.searchTextController.text.isEmpty) {
                          errorMessage("Veuillez remplir ce champs svp!");
                        }

                        //Search method
                        controller.search();
                      },
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
        // TextField(
        //   controller: controller.searchTextController,
        //   style: const TextStyle(color: Colors.white),
        //   decoration: const InputDecoration(
        //     hintText: "Search videos, users...",
        //     hintStyle: TextStyle(color: Colors.white54),
        //     border: InputBorder.none,
        //   ),
        //   onChanged: (value) {
        //     controller.searchTextController.text = value;
        //     controller.search();
        //   },
        // ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.results.isEmpty) {
          return const Center(
            child: Text("No results", style: TextStyle(color: Colors.white)),
          );
        }

        final videos = controller.results[0].videos!;
        if (_controllers.length != videos.length) {
          _controllersInitialized.value = false;
        }
        if (!_controllersInitialized.value) {
          Future.microtask(() => _initVideos(videos));
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 9 / 16,
          ),
          itemCount: controller.results[0].videos.length,
          itemBuilder: (context, index) {
            final item = controller.results[0].videos[index];
            final controllerVideo = _controllers[index];

            return GestureDetector(
              onTap: () {
                // Get.to(
                //   () => FullVideoScreen(videoUrl: item.videoUrl!),
                //   transition: Transition.fadeIn,
                //   duration: const Duration(milliseconds: 300),
                // );
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                color: Colors.black,
                child: Stack(
                  children: [
                    /// 🎥 FIRST FRAME
                    _controllers[index].value.isInitialized
                        ? SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _controllers[index].value.size.width,
                                height: _controllers[index].value.size.height,
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
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
  final String videoUrl;

  const FullVideoScreen({super.key, required this.videoUrl});

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  late VideoPlayerController _controller;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  Future<void> initVideo() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
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

                    /// ⏱️ Progress bar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.white,
                          bufferedColor: Colors.white30,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

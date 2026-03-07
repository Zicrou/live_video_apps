import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatelessWidget {
  final VideosController _actionsController = Get.put(VideosController());

@override
  void initState() {
    // super.initState();
    _initVideos();
  }

  // Future<void> _initVideos() async {
  //   await _actionsController.fetchVideos();

  //   final videos = _actionsController.videosList[0].videos!;
  //   for (final video in videos) {
  //     final controller = VideoPlayerController.networkUrl(
  //       Uri.parse(video.videoUrl!),
  //     );

  //     // await controller.initialize();
  //     // controller.setLooping(true);

  //     // _controllers.add(controller);

  //     await controller.initialize().then((_) {
  //       controller.setLooping(true);
  //       // setState(() {
  //       _controllers.add(controller);
        
  //       // _videoPaths.add(video.videoUrl!); // Add the video path

  //       // });
  //     });
  //   }

  //   setState(() {
  //     _controllersInitialized = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Tabs: My Videos, Likes, Saved, Shared
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.blueAccent,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Videos'),
              Tab(text: 'Likes'),
              Tab(text: 'Saved'),
              Tab(text: 'Shared'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVideoGrid(controller.myVideos), // My videos
            _buildVideoGrid(controller.likedVideos), // Liked videos
            _buildVideoGrid(controller.savedVideos), // Saved videos
            _buildVideoGrid(controller.sharedVideos), // Shared videos
          ],
        ),
      ),
    );
  }

  Widget _buildVideoGrid(RxList<Videos> videos) {
    return Obx(() {
      if (videos.isEmpty) {
        return const Center(child: Text('No videos found'));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // two videos per row
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final controller =
              VideoPlayerController.networkUrl(Uri.parse(video.videoUrl!));
              controller.initialize();
              controller.setLooping(true);

          return GestureDetector(
            onTap: () {
              // Play video in a new screen or inline
              Get.to(() => VideoPreviewScreen(controller: controller));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
                const Icon(
                  Icons.play_circle_outline,
                  size: 48,
                  color: Colors.white70,
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

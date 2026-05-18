import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/repositories/profile_repositories.dart';
import 'package:live_video_apps/app/modules/profiles/profiles_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfilesController profilesController = Get.put(ProfilesController());

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    print("ProfileScreen initState called : ${args?["ownerId"]}");
    profilesController.ownerId.value = args?["ownerId"] ?? "";
    profilesController.getProfile(profilesController.ownerId.value);
    print(
        "Videos list in profile screen initState: ${profilesController.ownerId.value}, ${profilesController.videos.toString()}");
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
    final args = Get.arguments;
    profilesController.ownerId.value = args?["ownerId"] ?? "";
    print("UserId in ProfileScreen: ${profilesController.videos.toString()}");

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
            _buildVideoGrid(profilesController.videos), // My videos
            _buildVideoGrid(profilesController.videos), // Liked videos
            _buildVideoGrid(profilesController.videos), // Saved videos
            _buildVideoGrid(profilesController.videos), // Shared videos
          ],
        ),
      ),
    );
  }

  Widget _buildVideoGrid(RxList<VideosInfo> videos) {
    return Obx(() {
      if (profilesController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (videos.isEmpty) {
        return Center(child: Text('No videos found'));
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
          final controller = VideoPlayerController.networkUrl(
              Uri.parse(video.videos![0].videoUrl!));
          controller.initialize();
          controller.setLooping(true);

          return GestureDetector(
              onTap: () {
                // Play video in a new screen or inline
                // Get.to(() => VideoPreviewScreen(controller: controller));
              },
              child: Container(
                  margin: const EdgeInsets.all(4),
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // controller.value.isInitialized ?
                      // SizedBox.expand(
                      AspectRatio(
                        aspectRatio: 2 / 2, // 🔥
                        child: VideoPlayer(controller),
                      ),
                      Icon(
                        Icons.play_circle_outline,
                        size: 48,
                        color: Colors.white70,
                      ),
                      // )
                    ],
                  )));
        },
      );
    });
  }
}

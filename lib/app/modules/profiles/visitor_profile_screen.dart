import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/repositories/profile_repositories.dart';
import 'package:live_video_apps/app/modules/profiles/profiles_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/video_item_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';
import 'package:video_player/video_player.dart';

class VisitorProfileScreen extends StatefulWidget {
  const VisitorProfileScreen({super.key});

  @override
  State<VisitorProfileScreen> createState() => _VisitorProfileScreenState();
}

class _VisitorProfileScreenState extends State<VisitorProfileScreen> {
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
          
          bottom: TabBar(
            
            onTap: (index) {
              
              if (index == 0) {
               
                profilesController.getProfile(profilesController.ownerId.value);
              
              }

            },
            tabs: [

              Tab(text: 'My Videos'),

            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVideoGrid(profilesController.videos), // My videos
          ],
        ),
      ),
    );
  }

  Widget _buildVideoGrid(RxList<VideosInfo> videos) {
    return Obx(() {
      if (profilesController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (videos.isEmpty) {
        return const Center(child: Text('No videos found'));
      }
      print("Videos list in profile screen build: ${videos.length}");
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
              Uri.parse(videos[0].videos[0].videoUrl!));
          controller.initialize();
          controller.setLooping(true);

          // In your grid item
            final selectedVideo = videos[index].videos.first;

            return GestureDetector(
              
              onTap: () {
                
                Get.to(
                  
                  () => VideoItemScreen(video: selectedVideo, isActive: true),
                
                );

              },

              child: Container(

                margin: const EdgeInsets.all(4),
                
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: VideoPlayer(controller),
                    ),
                    const Icon(
                      Icons.play_circle_outline,
                      size: 48,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            );
            
            }
          
      );
    });
  }
}

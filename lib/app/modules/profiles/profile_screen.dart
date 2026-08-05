import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/repositories/profile_repositories.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/app/modules/profiles/profiles_controller.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_controller.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_preview_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/video_item_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    profilesController.ownerId.value = args?["ownerId"] ?? "";
    print("UserId in ProfileScreen: ${profilesController.videos.toString()}");

  final followController = Get.find<FollowsController>();
  
  final authProvider = Get.find<AuthProvider>();
  
    return DefaultTabController(
      length: 4, // Tabs: My Videos, Likes, Saved, Shared
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.white,
          
        ),
        body: Column(
          children: [
            Obx(
              () => Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            profilesController.avatar.value.isEmpty
                                ? 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'
                                : profilesController.avatar.value,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            profilesController.username.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProfileStat(
                          profilesController.followersCount.value,
                          'Followers',
                        ),
                        _buildProfileStat(
                          profilesController.followingCount.value,
                          'Following',
                        ),
                        _buildProfileStat(
                          profilesController.likesCount.value,
                          'Likes',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // TabBar is now inside the body.
            Material(
              color: Colors.white,
              child: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blueAccent,
                onTap: (index) {
                  if (index == 0) {
                    profilesController.getProfile(
                      profilesController.ownerId.value,
                    );
                  }
                },
                tabs: const [
                  Tab(text: 'My Videos'),
                  Tab(text: 'Likes'),
                  Tab(text: 'Saved'),
                  Tab(text: 'Shared'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildVideoGrid(profilesController.videos),
                  _buildVideoGrid(profilesController.likedVideos),
                  _buildVideoGrid(profilesController.savedVideos),
                  _buildVideoGrid(profilesController.videos),
                ],
              ),
            ),
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

    Widget _buildProfileStat(int count, String label) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

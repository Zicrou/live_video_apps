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
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_button_screen.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_controller.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_controller.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_screen.dart';
import 'package:live_video_apps/app/modules/videos/search/search_videos_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/video_item_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos_features/top_bar_screen.dart';
import 'package:live_video_apps/app/routes/routes.dart';
import 'package:live_video_apps/utilites/dialogs/cannot_share_empty_video_dialog.dart';
import 'package:logger/web.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ...existing code...
final logger = Logger();

class VideosFollowingScreen extends StatefulWidget {
  const VideosFollowingScreen({super.key});

  @override
  State<VideosFollowingScreen> createState() => _VideosFollowingScreenState();
}

class _VideosFollowingScreenState extends State<VideosFollowingScreen> {
  final VideosController _actionsController =
      Get.isRegistered<VideosController>()
          ? Get.find<VideosController>()
          : Get.put(VideosController());
  final VideoController _video_controller = Get.put(VideoController());
  // final CommentsController commentsController = Get.put(CommentsController());
  final List<VideoPlayerController> _controllers = [];
  bool _controllersInitialized = false;
  // final followsController = Get.find<FollowsController>();
  // final commentsController = Get.find<CommentsController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_actionsController.authControler.authProvider.isAuthenticated) {
        print("User is authenticated in VideosFollowingScreen");

        _initVideos();
      } else {
        print("User is NOT authenticated in VideosFollowingScreen");

        Get.toNamed(Routes.login);
      }
    });
  }

  Future<void> _initVideos() async {
    await _actionsController.fetchVideosFollowing();
  }

  int currentIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // final List<String> _videoPaths = []; // Local picked videos or network URLs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 🔥 key for overlay effect
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: TopBar(),
        centerTitle: true,
      ),

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

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _actionsController.videosList[0].videos!.length,
          onPageChanged: (index) {
            onPageChanged(index);
          },
          itemBuilder: (context, index) {
            return VideoItemScreen(
              video: _actionsController.videosList[0].videos![index],
              isActive: index == currentIndex,
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

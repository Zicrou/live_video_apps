import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:live_video_apps/app/modules/videos/new_video/video_controller.dart';

import 'package:live_video_apps/app/modules/videos/new_video/video_screen.dart';

import 'package:live_video_apps/app/modules/videos/videos/video_item_screen.dart';

import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';

import 'package:logger/web.dart';

import 'package:video_player/video_player.dart';
// import 'package:flutter/physics.dart';


// ...existing code...
final logger = Logger();

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final VideosController _actionsController = Get.put(VideosController());
  final VideoController _video_controller = Get.put(VideoController());
  // final CommentsController commentsController = Get.put(CommentsController());
  final List<VideoPlayerController> _controllers = [];
  bool _controllersInitialized = false;
  // final followsController = Get.find<FollowsController>();
  // final commentsController = Get.find<CommentsController>();

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
      
      backgroundColor: Colors.black,
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

          pageSnapping: true,

          physics: const PageScrollPhysics(),

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

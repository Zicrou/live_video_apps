import 'package:flutter/material.dart';
import 'package:live_video_apps/app/data/services/api_services.dart';
import 'package:live_video_apps/app/modules/videos/learn_cloud/video_item_screen.dart';
import 'package:video_player/video_player.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List videos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  void fetchVideos() async {
    final data = await ApiService.getVideos();
    setState(() {
      videos = data;
      isLoading = false;
    });
  }

  // int currentIndex = 0;

  // void onPageChanged(int index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    int currentIndex = 0;

    void onPageChanged(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      onPageChanged: (index) {
        onPageChanged(index);
      },
      itemBuilder: (context, index) {
        return VideoItemScreen(
          video: videos[index],
          isActive: index == currentIndex,
        );
      },
    );
  }
}

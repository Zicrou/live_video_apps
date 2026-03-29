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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];

        return Column(
          children: [
            Text(video['title']),
            SizedBox(
              height: 300,
              child: VideoItemScreen(videoUrl: video['url']),
            ),
          ],
        );
        // VideoPlayerController.networkUrl(Uri.parse(video['url']));
      },
    );
  }
}

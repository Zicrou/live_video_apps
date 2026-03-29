import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItemScreen extends StatefulWidget {
  final String videoUrl;

  const VideoItemScreen({super.key, required this.videoUrl});

  @override
  State<VideoItemScreen> createState() => _VideoItemStateScreen();
}

class _VideoItemStateScreen extends State<VideoItemScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // autoplay
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        _controller.value.isPlaying ? _controller.pause() : _controller.play();
      },
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }
}

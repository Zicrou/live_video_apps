import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/modules/videos/learn_cloud/cloud_video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoItemScreen extends StatefulWidget {
  final dynamic video;
  final bool isActive;
  const VideoItemScreen(
      {super.key, required this.video, required this.isActive});

  @override
  State<VideoItemScreen> createState() => _VideoItemStateScreen();
}

class _VideoItemStateScreen extends State<VideoItemScreen> {
  late VideoPlayerController _controller;
  final CloudVideoController _videoController = Get.put(CloudVideoController());

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video['url']))
          ..initialize().then((_) {
            setState(() {});
            if (widget.isActive) {
              _controller.play(); // autoplay
            }
            _controller.setLooping(true);
          });

    if (widget.isActive) {
      _controller.play();
    }
  }

  @override
  void didUpdateWidget(covariant VideoItemScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive) {
      _controller.play();
    } else {
      _controller.pause();
    }
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
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        },
        child: Stack(
          children: [
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
            IconButton(
              icon: Icon(
                _videoController.isLiked
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _videoController.isLiked ? Colors.red : Colors.white,
              ),
              onPressed: () async {
                setState(() {
                  _videoController.isLiked = !_videoController.isLiked;
                });

                await _videoController
                    .toggleLike(widget.video['id'].toString());
              },
            )
          ],
        ));
  }
}

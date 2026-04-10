import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';

class RightActions extends StatelessWidget {
  final Videos video;
  const RightActions({required this.video});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideosController>();

    return Column(
      children: [
        Obx(
          () => IconButton(
            icon: Icon(
              Icons.favorite,
              color: video.isLiked! ? Colors.red : Colors.white,
              size: 32,
            ),
            onPressed: () {},
          ),
        ),
        Obx(
          () => Text(
            '${video.likeCount}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        IconButton(
          icon: const Icon(Icons.bookmark, color: Colors.white),
          onPressed: () => controller.toggleSave(video),
        ),
        const SizedBox(height: 16),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () => controller.shareVideo(video),
        ),
      ],
    );
  }
}

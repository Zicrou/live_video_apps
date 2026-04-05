import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_controller.dart';

class FollowsButtonScreen extends StatelessWidget {
  final dynamic video;

  const FollowsButtonScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowsController>();
    print(
        "userId: ${video.ownerId}, isFollowing: ${controller.followingMap[video.ownerId]}"); // Debug print
    return Obx(() {
      final isFollowing = controller.followingMap[video.ownerId] ?? false;
      // final isFollowing = controller.isFollowing.value;

      // 🔥 update THIS video only
      return GestureDetector(
        onTap: () {
          controller.toggleFollow(video.ownerId);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isFollowing ? Colors.grey : Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              isFollowing ? "Following" : "Follow",
              key: ValueKey(video.isFollowing.value),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    });
  }
}

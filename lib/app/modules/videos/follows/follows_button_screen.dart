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
      return SizedBox(
        width: 50,
        height: 60,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            /// 👤 AVATAR
            GestureDetector(
              onTap: () {
                // Navigate to profile
                print("Navigate to profile of userId: ${video.ownerId}");
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'), //AssetImage('assets/images/avatar.webp'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: isFollowing ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
              ),
            ),

            /// ➕ FOLLOW ICON
            Positioned(
              bottom: -2,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  controller.toggleFollow(video.ownerId);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFollowing ? Icons.check : Icons.add,
                    size: 16,
                    color: isFollowing ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
// Text(
            //   isFollowing ? "Following" : "Follow",
            //   key: ValueKey(video.isFollowing.value),
            //   style: const TextStyle(color: Colors.white),
            // ),
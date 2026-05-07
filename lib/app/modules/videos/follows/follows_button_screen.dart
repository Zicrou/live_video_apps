import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/profiles/profile_screen.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_controller.dart';

class FollowsButtonScreen extends StatelessWidget {
  final dynamic video;

  const FollowsButtonScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowsController>();
    print(
        "userId: ${video.ownerId}, isFollowing: ${controller.followingMap[video.ownerId]}"); // Debug print
    final authProvider = Get.find<AuthProvider>();
    print(
        "Video ownerId: ${video.ownerId}, Current userId: ${authProvider.user?.user?.id}"); // Debug print
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
                Get.to(ProfileScreen(), arguments: video.ownerId);
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
                  decoration: (video.ownerId != authProvider.user?.user?.id)
                      ? BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: Icon(
                    (video.ownerId != authProvider.user?.user?.id)
                        ? (isFollowing ? Icons.check : Icons.add)
                        : null, // Show person icon if it's the user's own video
                    size: 16,
                    color: (video.ownerId != authProvider.user?.user?.id)
                        ? (isFollowing ? Colors.green : Colors.red)
                        : Colors.grey, // Grey color for own video
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
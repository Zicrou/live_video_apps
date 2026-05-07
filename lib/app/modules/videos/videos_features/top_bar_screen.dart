import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/login.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/modules/videos/search/search_videos_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_following_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_screen.dart';
import 'package:live_video_apps/app/routes/routes.dart';
import 'package:path/path.dart';

class TopBar extends StatelessWidget {
  TopBar();
  VideosController videosController = Get.find<VideosController>();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            TextButton(
                onPressed: () {
                  // if (Get.currentRoute != Routes.videosFollowing) {
                  Get.toNamed(Routes.videosFollowing);
                  print("Going to VideosFollowingScreen");
                  // }
                },
                child: Text("Following",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: (Get.currentRoute == Routes.videosFollowing)
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 16))),
            SizedBox(width: 4),
            TextButton(
                onPressed: () {
                  print(
                      "Explore button pressed: current route: ${Get.currentRoute}");
                  // if (Get.currentRoute != Routes.home) {
                  Get.toNamed(Routes.home);
                  print("Going to VideosScreen");
                  // }
                },
                child: Text("Explore",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: (Get.currentRoute == Routes.home)
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 16)))
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.red),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: Colors.red))),
                ),
                onPressed: () => print("Go live button pressed"),
                child: Text("LIVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ),
            ),
            IconButton(
              onPressed: () => Get.to(SearchVideosScreen()),
              icon: const Icon(Icons.search, color: Colors.white, size: 24),
            ),
          ],
        )
      ],
    );
  }
}

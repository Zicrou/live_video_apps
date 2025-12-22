// /lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/live.dart';
import 'package:live_video_apps/app/modules/lives/livesController.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/pages/signup_screen.dart';
import 'package:live_video_apps/pages/viewer_feed_page.dart';
import 'package:logger/logger.dart';
import 'host_page.dart';
import 'viewer_page.dart';

Logger logger = Logger();

class HomePage extends StatelessWidget {
  final LivesController controller = Get.put(LivesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Video App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Start Live (Host)"),
              onPressed: () => Get.to(HostPage()),
            ),
            ElevatedButton(
              child: const Text("Watch Live (Viewers)"),
              onPressed: () {
                logger.i("Navigating to Viewer Page...");
                Get.to(ViewerPage());
                // Get.to(() => ViewerFeedPage(lives: controller.lives.toList()));
              },
              // () => Get.to(ViewerPage()),
            ),
          ],
        ),
      ),
    );
  }
}

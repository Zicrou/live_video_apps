// /lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/pages/signup_screen.dart';
import 'host_page.dart';
import 'viewer_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TikTok Live Clone")),
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
              onPressed: () =>
                  () => Get.to(ViewerPage()),
            ),
          ],
        ),
      ),
    );
  }
}

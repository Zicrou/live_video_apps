// /lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/videosArgs.dart';
import 'package:live_video_apps/app/initial_bindings.dart';
import 'package:live_video_apps/app/modules/auths/auth_binding.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/app/modules/profiles/profile_screen.dart';
import 'package:live_video_apps/app/modules/signup/signup_screen.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_preview_screen.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_screen.dart';
import 'package:live_video_apps/app/modules/videos/search/search_videos_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/video_item_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_following_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_screen.dart';
import 'package:live_video_apps/app/routes/routes.dart';
import 'package:live_video_apps/pages/home_page.dart';

void main() {
  runApp(const LiveApp());
}

class LiveApp extends StatelessWidget {
  const LiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.home,
      debugShowCheckedModeBanner: false,
      initialBinding: AppInitialBindings(),
      home: LoginScreen(),
    );
  }
}

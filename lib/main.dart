// /lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/initial_bindings.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/pages/home_page.dart';

void main() {
  runApp(const LiveApp());
}

class LiveApp extends StatelessWidget {
  const LiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppInitialBindings(),
      home: HomePage(),
    );
  }
}

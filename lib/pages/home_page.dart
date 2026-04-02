// /lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/repositories/comments_repository.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/lives/livesController.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/app/modules/signup/signup_screen.dart';
import 'package:live_video_apps/app/modules/videos/learn_cloud/video_list_screen.dart';
import 'package:live_video_apps/app/modules/videos/search/search_videos_controller.dart';
import 'package:live_video_apps/app/modules/videos/search/search_videos_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_screen.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class HomePage extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();
  VideosRepositories _videosRepositories = VideosRepositories();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Video App"),
        backgroundColor: Color.fromARGB(255, 0, 173, 253),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Déconnexion"),
                    content: Text(
                      "Êtes-vous sûr de vouloir vous déconnecter ?",
                    ),
                    actions: [
                      TextButton(
                        child: Text("Annuler"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Se déconnecter"),
                        onPressed: () async {
                          Navigator.of(context).pop(); // Close the dialog
                          await controller.logout();
                          Get.to(() => LoginScreen());
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Login"),
              onPressed: () => Get.to(LoginScreen()),
              // onPressed: () => Get.to(HostPage()),
            ),
            ElevatedButton(
              child: const Text("Sign Up"),
              onPressed: () {
                logger.i("Navigating to Sign Up Page...");
                Get.to(SignupScreen());
              },
              // () => Get.to(ViewerPage()),
            ),
            ElevatedButton(
              child: const Text("Videos"),
              onPressed: () {
                logger.i("Videos page...");
                // VideosRepositories().toggleFollow(
                //     "b4bf210c-83b1-4034-86e7-68e710a7f1bd"); // Test toggle follow function
                Get.to(VideosScreen());

                // Test Share videos function

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

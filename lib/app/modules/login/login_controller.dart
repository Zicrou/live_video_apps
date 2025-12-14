import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/services/auth_services.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LoginController extends GetxController {
  final auth_services = Get.find<AuthServices>();

  @override
  void onInit() {
    super.onInit();
    // Initialize any necessary data or state here
  }

  void login() async {
    try {} catch (e) {
      throw ("Impossible de se connecter ${e}");
    }
  }
}

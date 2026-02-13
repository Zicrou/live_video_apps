import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:live_video_apps/app/data/services/auth_services.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class SignupController extends GetxController {
  final auth_services = Get.find<AuthServices>();

  @override
  void onInit() {
    super.onInit();
    // Initialize any necessary data or state here
  }

  void signup() async {
    try {} catch (e) {
      throw ("Impossible de s'inscrire $e");
    }
  }
}

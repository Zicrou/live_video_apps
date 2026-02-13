import 'package:get/get.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/repositories/auth_repositories.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/signup/Signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthProvider());
    Get.put(SignupController());
    Get.put(AuthRepositories());
    Get.put(AuthController());
  }
}

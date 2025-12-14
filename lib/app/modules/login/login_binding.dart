import 'package:get/get.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/repositories/auth_repositories.dart';
import 'package:live_video_apps/app/modules/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthProvider());
    Get.put(LoginController());
    Get.put(AuthRepositories());
  }
}

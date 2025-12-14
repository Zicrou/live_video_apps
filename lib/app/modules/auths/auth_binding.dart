import 'package:get/get.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => AuthProvider());
    Get.put(() => AuthController());
  }
}

import 'package:get/get.dart';
import 'package:live_video_apps/app/data/repositories/auth_repositories.dart';
import 'package:live_video_apps/app/modules/videos/videos/video_actions_controller.dart';

class VideosBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => DepensesController());
    Get.put(AuthRepositories());
    Get.put(VideoActionsController());
  }
}

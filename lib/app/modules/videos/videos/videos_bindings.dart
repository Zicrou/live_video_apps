import 'package:get/get.dart';
import 'package:live_video_apps/app/data/repositories/auth_repositories.dart';
import 'package:live_video_apps/app/data/services/remote_services.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';

class VideosBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => DepensesController());
    Get.put(AuthRepositories());
    Get.put(VideosController());
    Get.put(RemoteServices());
  }
}

import 'package:get/get.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';
import 'package:live_video_apps/app/data/services/remote_services.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_controller.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';

class VenteBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideosRepositories()); // Assuming TypesController is needed here
    Get.put(RemoteServices());
    Get.lazyPut(() => VideosController());
    Get.lazyPut(() => VideoController());
    Get.put(FollowsController());
  }
}

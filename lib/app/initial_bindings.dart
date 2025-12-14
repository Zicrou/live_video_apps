import 'package:get/get.dart';
import 'package:live_video_apps/app/data/providers/api_providers.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/providers/storage_providers.dart';
import 'package:live_video_apps/app/data/repositories/auth_repositories.dart';
import 'package:live_video_apps/app/data/services/auth_services.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/login/login_controller.dart';

class AppInitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageProvider(), permanent: true);
    Get.put(AuthProvider(), permanent: true);
    Get.put(ApiProvider());

    Get.put(AuthRepositories()); // MUST come before AuthServices
    Get.lazyPut(() => AuthServices());
    // Get.put(RemoteServices());
    // safe to find dependencies
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => AuthController());
  }
}

import 'package:live_video_apps/app/data/models/live.dart';
import 'package:live_video_apps/app/data/providers/storage_providers.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';

final logger = Logger();

class LiveProviders extends GetxService {
  final _storageProvider = Get.find<StorageProvider>();
  final _live = Live().obs;
  final _livesToken = ''.obs;
  // final _isLiveActive = false.obs;
  Live get live => _live.value;
  set live(Live live) {
    _live.value = live;
  }

  String get livesToken => _livesToken.value;

  set livesToken(String token) {
    _livesToken.value = token;
  }

  @override
  void onInit() {
    super.onInit();
    _live.value = _storageProvider.currentLive ?? Live();
    // _livesToken.value = _storageProvider.currentLive ?? '';
  }
}

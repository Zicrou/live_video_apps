import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/services/auth_services.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/app/utils/messages.dart';
import 'package:live_video_apps/pages/home_page.dart';
import 'package:live_video_apps/services/api.dart';
import 'package:logger/web.dart';

Logger logger = Logger();

class Livescontroller extends GetxController {
  ApiService apiService = ApiService();
  late RtcEngine _engine;
  RxBool _initialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchLives();
  }

  Future<void> fetchLives() async {
    logger.i("Storing live for host ...");
    var response = await apiService.fetchListLives(
      "4|xB1f3IkRGBSk4grNYsgKfdXNDBeyz8AWAiFHZoGJ7b761875",
    );
    logger.i("Response Store Live: $response");
  }

  Future<void> storeLive() async {
    logger.i("Storing live for host ...");
    var response = await apiService.storeLive(
      "4|xB1f3IkRGBSk4grNYsgKfdXNDBeyz8AWAiFHZoGJ7b761875",
    );
    logger.i("Response Store Live: $response");
    // AuthController authController = Get.find<AuthController>();
    // token = await ApiService.getHostToken(
    //   "4|xB1f3IkRGBSk4grNYsgKfdXNDBeyz8AWAiFHZoGJ7b761875",
    // ); // UserToken
  }

  Future<void> startLive() async {
    final token = await ApiService.getHostToken("UserToken");
    //"007eJxTYIj0iv3QXsbwrer7022X9Gas/TdTzGPJFlUf3wpm928MX1MUGAwNzBMtDc1NDI3SEk0sE80tjSxMLE2NjCxNTJOTUsyNtm03zWwIZGRQSclgZWSAQBCfhyEjv7gkPjkjMS8vNYeBAQBnFyIV"; //

    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: ApiService.appId));

    // await _engine.initialize(
    //   const RtcEngineContext(appId: "107a917412fa49a792849522945cbd72"),
    // );

    await _engine.enableVideo();
    await _engine.startPreview();

    _engine.registerEventHandler(
      RtcEngineEventHandler(onJoinChannelSuccess: (c, uid) {}),
    );

    await _engine.joinChannel(
      token: token,
      channelId: "host_channel",
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    _initialized.value = true;
  }
}

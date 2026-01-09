import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/live.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/services/auth_services.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/app/utils/messages.dart';
import 'package:live_video_apps/pages/home_page.dart';
import 'package:live_video_apps/services/api_services.dart';
import 'package:logger/web.dart';

Logger logger = Logger();

class LivesController extends GetxController {
  ApiServices apiService = ApiServices();
  late RtcEngine _engine;
  final userToken = "6|nLXfQ2leXiMRuzYGRdp7ijIHziAr2SD2s1aB9hQc9d5e613e";
  RxBool _initialized = false.obs;
  RxList<Live> lives = <Live>[].obs;

  @override
  void onInit() {
    super.onInit();
    startLive();
  }

  Future<void> fetchLives() async {
    logger.i("Storing live for host ...");
    var response = await apiService.fetchListLives(userToken);
    // lives.value = response;
    lives.assignAll(response);

    logger.i("Response List Lives fetched: $lives");
  }

  Future<void> storeLive() async {
    logger.i("Storing live for host ...");
    var response = await apiService.storeLives(userToken);

    logger.i("Response Store Live: $response");

    // AuthController authController = Get.find<AuthController>();
    // token = await ApiService.getHostToken(
    //   userToken,
    // ); // UserToken
  }

  Future<void> startLive() async {
    logger.i("Starting live for host ...");
    final live = await apiService.startLives(userToken);
    //"007eJxTYIj0iv3QXsbwrer7022X9Gas/TdTzGPJFlUf3wpm928MX1MUGAwNzBMtDc1NDI3SEk0sE80tjSxMLE2NjCxNTJOTUsyNtm03zWwIZGRQSclgZWSAQBCfhyEjv7gkPjkjMS8vNYeBAQBnFyIV"; //

    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: ApiServices.appId));

    // await _engine.initialize(
    //   const RtcEngineContext(appId: "107a917412fa49a792849522945cbd72"),
    // );

    await _engine.enableVideo();
    await _engine.startPreview();

    _engine.registerEventHandler(
      RtcEngineEventHandler(onJoinChannelSuccess: (c, uid) {}),
    );

    await _engine.joinChannel(
      token: live.data['liveToken'],
      channelId: live.data['channel_name'],
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    _initialized.value = true;
  }
}

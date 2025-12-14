// /lib/pages/host_page.dart
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:logger/web.dart';
import '../services/api.dart';

Logger logger = Logger();

class HostPage extends StatefulWidget {
  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  late RtcEngine _engine;
  bool _initialized = false;
  // late String token;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    storeLive();
  }

  Future<void> storeLive() async {
    logger.i("Storing live for host ...");
    var response = await apiService.fetchListLives(
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

    setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: Stack(
        children: [
          AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end),
                  onPressed: () async {
                    await _engine.leaveChannel();
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.switch_camera),
                  onPressed: () => _engine.switchCamera(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

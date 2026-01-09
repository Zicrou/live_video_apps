// /lib/pages/host_page.dart
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/lives/livesController.dart';
import 'package:live_video_apps/services/api_services.dart';
import 'package:logger/web.dart';

Logger logger = Logger();

class HostPage extends StatefulWidget {
  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  late RtcEngine _engine;
  bool _initialized = false;
  // late String token;
  ApiServices apiService = ApiServices();
  final userToken = "6|nLXfQ2leXiMRuzYGRdp7ijIHziAr2SD2s1aB9hQc9d5e613e";
  // Livescontroller livescontroller = Get.put(Livescontroller());

  @override
  void initState() {
    super.initState();
    startLives();
  }

  Future<void> fetchLives() async {
    logger.i("Storing live for host ...");
    var response = await apiService.fetchListLives(userToken);
    logger.i("Response Store Live: $response");
  }

  Future<void> storeLives() async {
    logger.i("Storing live for host ...");
    var response = await apiService.storeLives(userToken);
    logger.i("Response Store Live: $response");
    // AuthController authController = Get.find<AuthController>();
    // token = await ApiService.getHostToken(
    //   ,
    // ); // UserToken
  }

  Future<void> getLive() async {
    logger.i("Storing live for host ...");
    var response = await apiService.getLive(userToken);
    logger.i("Response Store Live: $response");
  }

  Future<void> startLives() async {
    // final data =
    //     await ApiServices.getHostToken("test_channel") as Map<String, dynamic>;
    var channelName = "test_channel"; // data['channel'];
    var token =
        "007eJxTYJh+/qrtM8VfTOdm3eIVyLj+830f5zP3yuWVR5fwOz0wmHZAgcHQwDzR0tDcxNAoLdHEMtHc0sjCxNLUyMjSxDQ5KcXc6EN6QiZDWULmkautrIwMjAwsQAwCTGCSGUyygEkehpLU4pL45IzEvLzUHEYGAwBImyRg"; //"007eJxTYHgmdnJfvuvXK+91Hklu44wMuNVeYR44x2tHXcLG/1EGy6UUGAwNzBMtDc1NDI3SEk0sE80tjSxMLE2NjCxNTJOTUsyNSp2CMxsCGRlSSyYzMjJAIIjPwZCTWZYab2hkzMAAANecH6Y=";
    // var liveStarted = startLive.data;
    logger.i("TOKEN FROM START LIVE: token: $token, channel: $channelName");

    // logger.i("ChannelName FROM START LIVE: ${liveStarted['channel_name']}");
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: ApiServices.appId));

    await _engine.enableVideo();
    await _engine.startPreview();

    _engine.registerEventHandler(
      RtcEngineEventHandler(onJoinChannelSuccess: (c, uid) {}),
    );

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    setState(() => _initialized = true);

    await _engine.initialize(RtcEngineContext(appId: ApiServices.appId));

    await _engine.enableVideo();

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await _engine.startPreview();

    // await _engine.joinChannel(
    //   token: token,
    //   channelId: channelName,
    //   uid: 0,
    //   options: const ChannelMediaOptions(
    //     publishCameraTrack: true,
    //     publishMicrophoneTrack: true,
    //   ),
    // );
  }

  Future<void> stopLives() async {
    final startLive = await apiService.stopLives(userToken);
    return;
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
                    await stopLives();
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

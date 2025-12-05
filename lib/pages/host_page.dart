// /lib/pages/host_page.dart
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../services/api.dart';

class HostPage extends StatefulWidget {
  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  late RtcEngine _engine;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    startLive();
  }

  Future<void> startLive() async {
    final token =
        "007eJxTYLhWIlzD9KCmYM96Nx/75OO3mW//mf4zW69PyNunr2mjwSYFBkMD80RLQ3MTQ6O0RBPLRHNLIwsTS1MjI0sT0+SkFHMjCxujzIZARob2hWGMjAwQCOLzMGTkF5fEJ2ck5uWl5jAwAAATySEY"; //await ApiService.getHostToken("host_channel");

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(appId: "107a917412fa49a792849522945cbd72"),
    );

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

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class ViewerPage extends StatefulWidget {
  const ViewerPage({super.key});

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  final _engine = createAgoraRtcEngine();
  int? remoteUid; // ← store remote user ID safely

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await _engine.initialize(
      const RtcEngineContext(appId: "107a917412fa49a792849522945cbd72"),
    );

    // Register event handler
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          print("Remote user joined: $uid");
          setState(() {
            remoteUid = uid;
          });
        },
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) {
              print("Remote user left");
              setState(() {
                remoteUid = null;
              });
            },
      ),
    );

    await _engine.enableVideo();

    await _engine.joinChannel(
      token:
          "007eJxTYLhWIlzD9KCmYM96Nx/75OO3mW//mf4zW69PyNunr2mjwSYFBkMD80RLQ3MTQ6O0RBPLRHNLIwsTS1MjI0sT0+SkFHMjCxujzIZARob2hWGMjAwQCOLzMGTkF5fEJ2ck5uWl5jAwAAATySEY",
      channelId: "host_channel",
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: remoteUid == null
            ? const Text(
                "Waiting for host...",
                style: TextStyle(color: Colors.white),
              )
            : AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _engine,
                  canvas: VideoCanvas(uid: remoteUid),
                  connection: const RtcConnection(channelId: "host_channel"),
                ),
              ),
      ),
    );
  }
}

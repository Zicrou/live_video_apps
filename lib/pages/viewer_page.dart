import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live_video_apps/services/api_services.dart';

class ViewerPage extends StatefulWidget {
  const ViewerPage({super.key});

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _joined = false;

  @override
  void initState() {
    super.initState();
    joinLive();
  }

  Future<void> joinLive() async {
    // final token = await ApiServices.getViewerToken("host_channel");
    final token =
        "007eJxTYFDtvM1Vs0pr61K+a5JxJ7TuaP+6q/bjd16SF++V2Odu9UsVGAwNzBMtDc1NDI3SEk0sE80tjSxMLE2NjCxNTJOTUsyNPqQnZDKUJWTeya1nYIRCEOBhKEktLolPzkjMy0vNYWQwAAB+uiKl";
    //"007eJxTYHgmdnJfvuvXK+91Hklu44wMuNVeYR44x2tHXcLG/1EGy6UUGAwNzBMtDc1NDI3SEk0sE80tjSxMLE2NjCxNTJOTUsyNSp2CMxsCGRlSSyYzMjJAIIjPwZCTWZYab2hkzMAAANecH6Y=";
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(appId: "107a917412fa49a792849522945cbd72"),
    );

    await _engine.enableVideo();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, uid) {
          setState(() => _joined = true);
        },
        onUserJoined: (connection, uid, elapsed) {
          setState(() => _remoteUid = uid);
        },
        onUserOffline: (connection, uid, reason) {
          setState(() => _remoteUid = null);
        },
      ),
    );

    await _engine.joinChannel(
      token: token,
      channelId: "test_channel",
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: _buildVideoView()));
  }

  Widget _buildVideoView() {
    // 1️⃣ Not joined yet
    if (!_joined) {
      return const CircularProgressIndicator();
    }

    // 2️⃣ Joined but host not publishing yet
    if (_remoteUid == null) {
      return const Text(
        "Waiting for host to go live...",
        style: TextStyle(fontSize: 16),
      );
    }

    // 3️⃣ Host is publishing (SAFE)
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: _remoteUid),
        connection: const RtcConnection(channelId: "test_channel"),
      ),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }
}

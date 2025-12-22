// /lib/pages/viewer_feed_page.dart
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:live_video_apps/app/data/models/live.dart';
import 'package:live_video_apps/app/modules/lives/livesController.dart';
import 'package:live_video_apps/services/api_services.dart';

class ViewerFeedPage extends StatefulWidget {
  final List<Live> lives;

  const ViewerFeedPage({super.key, required this.lives});

  @override
  State<ViewerFeedPage> createState() => _ViewerFeedPageState();
}

class _ViewerFeedPageState extends State<ViewerFeedPage> {
  // LivesController controller = Get.put(LivesController());
  RtcEngine? _engine;
  int? _remoteUid;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _joinLive(0);
  }

  Future<void> _joinLive(int index) async {
    final live = widget.lives[index];

    // Leave previous
    if (_engine != null) {
      await _engine!.leaveChannel();
      await _engine!.release();
    }

    _remoteUid = null;

    final token = await ApiServices.getViewerToken(live.channelName!);

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: ApiServices.appId));

    await _engine!.enableVideo();

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (connection, uid, elapsed) {
          setState(() => _remoteUid = uid);
        },
        onUserOffline: (connection, uid, reason) {
          setState(() => _remoteUid = null);
        },
      ),
    );

    await _engine!.joinChannel(
      token: token,
      channelId: live.channelName!,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
      ),
    );
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.lives.length,
        onPageChanged: (index) {
          _currentIndex = index;
          _joinLive(index);
        },
        itemBuilder: (context, index) {
          final live = widget.lives[index];

          return Stack(children: [_buildVideoView(index), _buildOverlay(live)]);
        },
      ),
    );
  }

  Widget _buildVideoView(int index) {
    if (index != _currentIndex || _remoteUid == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(uid: _remoteUid),
        connection: RtcConnection(
          channelId: widget.lives[_currentIndex].channelName,
        ),
      ),
    );
  }

  Widget _buildOverlay(Live live) {
    return Positioned(
      bottom: 40,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            live.title ?? "Live",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Viewers: ${live.viewersCount ?? 0}",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

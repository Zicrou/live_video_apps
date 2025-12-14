import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../services/api.dart';

class ViewerPage extends StatefulWidget {
  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    joinLive();
  }

  Future<void> joinLive() async {
    final token = await ApiService.getViewerToken("host_channel");

    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: ApiService.appId));

    await _engine.enableVideo();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          setState(() => _remoteUid = uid);
        },
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) {
              setState(() => _remoteUid = null);
            },
      ),
    );

    await _engine.joinChannel(
      token: token,
      channelId: "host_channel",
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
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
            controller: VideoViewController.remote(
              rtcEngine: _engine,
              canvas: VideoCanvas(uid: _remoteUid),
              connection: const RtcConnection(channelId: "host_channel"),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';

// class ViewerPage extends StatefulWidget {
//   const ViewerPage({super.key});

//   @override
//   State<ViewerPage> createState() => _ViewerPageState();
// }

// class _ViewerPageState extends State<ViewerPage> {
//   final _engine = createAgoraRtcEngine();
//   int? remoteUid; // ← store remote user ID safely

//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//   Future<void> initAgora() async {
//     await _engine.initialize(
//       const RtcEngineContext(appId: "107a917412fa49a792849522945cbd72"),
//     );

//     // Register event handler
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onUserJoined: (RtcConnection connection, int uid, int elapsed) {
//           print("Remote user joined: $uid");
//           setState(() {
//             remoteUid = uid;
//           });
//         },
//         onUserOffline:
//             (RtcConnection connection, int uid, UserOfflineReasonType reason) {
//               print("Remote user left");
//               setState(() {
//                 remoteUid = null;
//               });
//             },
//       ),
//     );

//     await _engine.enableVideo();

//     await _engine.joinChannel(
//       token:
//           "007eJxTYIj0iv3QXsbwrer7022X9Gas/TdTzGPJFlUf3wpm928MX1MUGAwNzBMtDc1NDI3SEk0sE80tjSxMLE2NjCxNTJOTUsyNtm03zWwIZGRQSclgZWSAQBCfhyEjv7gkPjkjMS8vNYeBAQBnFyIV",
//       channelId: "host_channel",
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: remoteUid == null
//             ? const Text(
//                 "Waiting for host...",
//                 style: TextStyle(color: Colors.white),
//               )
//             //Add a buttun to leave the channel and go back to HomePage
//             : AgoraVideoView(
//                 controller: VideoViewController.remote(
//                   rtcEngine: _engine,
//                   canvas: VideoCanvas(uid: remoteUid),
//                   connection: const RtcConnection(channelId: "host_channel"),
//                 ),
//               ),
//       ),
//     );
//   }
// }

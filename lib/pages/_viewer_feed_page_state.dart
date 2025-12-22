// class _ViewerFeedPageState extends State<ViewerFeedPage> {
//   RtcEngine? _engine;
//   int? _remoteUid;
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _joinLive(0);
//   }

//   Future<void> _joinLive(int index) async {
//     final live = widget.lives[index];

//     // Leave previous
//     if (_engine != null) {
//       await _engine!.leaveChannel();
//       await _engine!.release();
//     }

//     _remoteUid = null;

//     final token = await ApiService.getViewerToken(live.channelName!);

//     _engine = createAgoraRtcEngine();
//     await _engine!.initialize(
//       RtcEngineContext(appId: ApiService.appId),
//     );

//     await _engine!.enableVideo();

//     _engine!.registerEventHandler(
//       RtcEngineEventHandler(
//         onUserJoined: (connection, uid, elapsed) {
//           setState(() => _remoteUid = uid);
//         },
//         onUserOffline: (connection, uid, reason) {
//           setState(() => _remoteUid = null);
//         },
//       ),
//     );

//     await _engine!.joinChannel(
//       token: token,
//       channelId: live.channelName!,
//       uid: 0,
//       options: const ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleAudience,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _engine?.leaveChannel();
//     _engine?.release();
//     super.dispose();
//   }

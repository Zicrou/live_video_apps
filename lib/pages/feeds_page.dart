// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// class FeedPage extends StatefulWidget {
//   final String userToken;
//   const FeedPage({super.key, required this.userToken});

//   @override
//   State<FeedPage> createState() => _FeedPageState();
// }

// class _FeedPageState extends State<FeedPage> {
//   // List<FeedItem> feed = [];
//   Map<String, RtcEngine> engines = {};
//   Map<String, VideoPlayerController> videoControllers = {};

//   @override
//   void initState() {
//     super.initState();
//     loadFeed();
//   }

//   Future<void> loadFeed() async {
//     // final fetchedFeed = await ApiService.fetchFeed(widget.userToken);
//     // fetch live tokens
//     // for (var item in fetchedFeed) {
//     //   if (item.type == ContentType.live) {
//     //     item.liveToken = await ApiService.getToken(item.channelName!, 'viewer');
//     //   }
//     // }
//     // setState(() => feed = fetchedFeed);
//   }

//   // Future<RtcEngine> initAgora(FeedItem live) async {
//   //   if (engines.containsKey(live.channelName))
//   //     return engines[live.channelName]!;

//   //   final engine = createAgoraRtcEngine();
//   //   await engine.initialize(RtcEngineContext(appId: "YOUR_AGORA_APP_ID"));
//   //   await engine.enableVideo();

//   //   await engine.joinChannel(
//   //     token: live.liveToken,
//   //     channelId: live.channelName!,
//   //     uid: 0,
//   //     options: const ChannelMediaOptions(
//   //       clientRoleType: ClientRoleType.clientRoleAudience,
//   //     ),
//   //   );

//   //   engines[live.channelName!] = engine;
//   //   return engine;
//   // }

//   // Future<VideoPlayerController> initVideo(FeedItem video) async {
//   //   if (videoControllers.containsKey(video.videoUrl))
//   //     return videoControllers[video.videoUrl]!;

//   //   final controller = VideoPlayerController.network(video.videoUrl!)
//   //     ..initialize().then((_) => controller.play());
//   //   videoControllers[video.videoUrl!] = controller;
//   //   return controller;
//   // }

//   @override
//   void dispose() {
//     for (var engine in engines.values) {
//       engine.leaveChannel();
//       engine.release();
//     }
//     for (var controller in videoControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (feed.isEmpty)
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));

//     return Scaffold(
//       body: PageView.builder(
//         scrollDirection: Axis.vertical,
//         itemCount: feed.length,
//         itemBuilder: (context, index) {
//           final item = feed[index];

//           return VisibilityDetector(
//             key: Key(
//               item.type == ContentType.live
//                   ? item.channelName!
//                   : item.videoUrl!,
//             ),
//             onVisibilityChanged: (info) async {
//               if (info.visibleFraction > 0.5) {
//                 if (item.type == ContentType.live) {
//                   final engine = await initAgora(item);
//                   await engine.resumeAllVideo();
//                 } else {
//                   final controller = await initVideo(item);
//                   controller.play();
//                 }
//               } else {
//                 if (item.type == ContentType.live) {
//                   final engine = engines[item.channelName];
//                   engine?.pauseAllVideo();
//                 } else {
//                   final controller = videoControllers[item.videoUrl];
//                   controller?.pause();
//                 }
//               }
//             },
//             child: Stack(
//               children: [
//                 if (item.type == ContentType.live)
//                   FutureBuilder<RtcEngine>(
//                     future: initAgora(item),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData)
//                         return const Center(child: CircularProgressIndicator());
//                       return AgoraVideoView(
//                         controller: VideoViewController.remote(
//                           rtcEngine: snapshot.data!,
//                           canvas: const VideoCanvas(uid: 0),
//                           connection: RtcConnection(
//                             channelId: item.channelName!,
//                           ),
//                         ),
//                       );
//                     },
//                   )
//                 else
//                   FutureBuilder<VideoPlayerController>(
//                     future: initVideo(item),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData)
//                         return const Center(child: CircularProgressIndicator());
//                       final controller = snapshot.data!;
//                       return Center(
//                         child: AspectRatio(
//                           aspectRatio: controller.value.aspectRatio,
//                           child: VideoPlayer(controller),
//                         ),
//                       );
//                     },
//                   ),
//                 // Like & Share
//                 Positioned(
//                   right: 16,
//                   bottom: 80,
//                   child: Column(
//                     children: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.favorite,
//                           color: Colors.red,
//                           size: 40,
//                         ),
//                         onPressed: () => print("Liked ${item.title}"),
//                       ),
//                       const SizedBox(height: 16),
//                       IconButton(
//                         icon: const Icon(
//                           Icons.share,
//                           color: Colors.white,
//                           size: 35,
//                         ),
//                         onPressed: () => print("Shared ${item.title}"),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Title
//                 Positioned(
//                   left: 16,
//                   bottom: 16,
//                   child: Text(
//                     item.title ?? "Content by ${item.hostUserId ?? 'Unknown'}",
//                     style: const TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

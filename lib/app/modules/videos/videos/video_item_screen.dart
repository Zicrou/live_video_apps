import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:live_video_apps/app/data/models/videosArgs.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/modules/comments/comments/comments_controller.dart'
    hide logger;
import 'package:live_video_apps/app/modules/comments/comments/comments_screen.dart'
    hide logger;
import 'package:live_video_apps/app/modules/login/login_screen.dart'
    hide logger;
import 'package:live_video_apps/app/modules/videos/follows/follows_button_screen.dart';
import 'package:live_video_apps/app/modules/videos/follows/follows_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart'
    hide logger;
import 'package:live_video_apps/utilites/dialogs/cannot_share_empty_video_dialog.dart';
import 'package:live_video_apps/utilites/dialogs/should_get_connected_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoItemScreen extends StatefulWidget {
  final dynamic video;
  final bool isActive;

  const VideoItemScreen({
    super.key,
    required this.video,
    required this.isActive,
  });

  @override
  State<VideoItemScreen> createState() => _VideoItemScreenState();
}

class _VideoItemScreenState extends State<VideoItemScreen> {
  late VideoPlayerController _controller;
  final actionsController = Get.isRegistered<VideosController>()
      ? Get.find<VideosController>()
      : Get.put(VideosController());
  final followsController = Get.find<FollowsController>();
  final commentsController = Get.find<CommentsController>();
  // final dynamic args = Get.arguments;
  final authProvider = Get.find<AuthProvider>();

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl!))
          ..initialize().then((_) {
            setState(() {});
            if (widget.isActive == true) {
              _controller.play();
            }
            _controller.setLooping(true);
          });

    // if (widget.isActive) {
    //   _controller.play();
    // }
  }

  @override
  void didUpdateWidget(covariant VideoItemScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive == true) {
      _controller.play();
    } else {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  dynamic noData() {
    return Scaffold(body: Text("No data"));
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.video == null) {
    //   return noData();
    // }
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
// Initialize isLiked  and isSaved in the controller based on the video state
    actionsController.isLiked.value = widget.video.isLiked!;
    actionsController.isSaved.value = widget.video.isSaved!;

    var videoInfo = widget.video;
    return VisibilityDetector(
        key: Key("video-${widget.video.id}"), // 🔥 VERY IMPORTANT (unique key)
        onVisibilityChanged: (info) {
          if (widget.isActive == true && info.visibleFraction > 0.7) {
            _controller.play();
          } else {
            // if (_controller.dispose() != true) {
            _controller.pause();
            // }
          }
        },
        child: GestureDetector(
            onTap: () {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            },
            child: Stack(
              children: [
                // Video
                Stack(
                  children: [
                    ClipRRect(
                      child: Container(
                        color: Colors.black,
                        child: SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller.value.size.width,
                              height: _controller.value.size.height,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// ⏱️ PROGRESS BAR (no time)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true, // optional (user can seek)
                        colors: VideoProgressColors(
                          playedColor: Colors.white,
                          bufferedColor: Colors.white30,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                    ),
                  ],
                ),

                /// ❤️ RIGHT ACTIONS
                Positioned(
                  right: 12,
                  bottom: 120,
                  child: Builder(
                    builder: (context) {
                      return Obx(() {
                        final state = widget.video;

                        if (state == null) {
                          print(
                              "State Comment count videos: ${state.commentCount}");
                          return const SizedBox.shrink();
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // if (state.ownerId != actionsController.user_id)
                            FollowsButtonScreen(video: state),
                            Text(
                              actionsController.formatCount(
                                  followsController.followersCount.value),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // ❤️ LIKE
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: actionsController.isLiked.value
                                    ? Colors.red
                                    : Colors.white,
                                size: 32,
                              ),
                              onPressed: () {
                                print(
                                    "IsLiked before toggle: ${actionsController.isLiked.value}");
                                if (authProvider.user?.user?.id == null) {
                                  showShouldGetConnectedDialog(context, "like");
                                  return;
                                } else {
                                  actionsController.toggleLike(state);
                                }
                                print(
                                    "IsLiked after toggle: ${actionsController.isLiked.value}");
                              },
                            ),
                            Text(
                              actionsController.formatCount(state.likeCount!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 💬 COMMENT
                            IconButton(
                              icon: const Icon(
                                Icons.comment,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                // void openComments(videoId) {
                                print("Video id:: ${widget.video.id}");
                                Get.bottomSheet(
                                    CommentSheet(videoId: widget.video.id!),
                                    isScrollControlled: true);
                                print(
                                    "Comment count from screen : ${widget.video.commentCount}");
                                // }
                              },
                            ),
                            Text(
                              '${(commentsController.commentsCountChanged.value == true) ? state.commentCount : videoInfo.commentCount}', // Display the comment count // 31
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 💾 SAVE
                            IconButton(
                              icon: Icon(
                                Icons.bookmark,
                                color: actionsController.isSaved.value
                                    ? Colors.yellow
                                    : Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                if (authProvider.user?.user?.id == null) {
                                  showShouldGetConnectedDialog(context, "save");
                                  return;
                                } else {
                                  actionsController.toggleSave(state);
                                }
                                logger.i(
                                  "After toggling save for video at index ${state.id}, ${state.videoUrl}, current state: ${state.isSaved}, savedCount: ${state.savedCount}",
                                );
                                // if (state.isSaved!) {
                                //   logger.i(
                                //     "Video at index ${state.id} is now saved.",
                                //   );
                                // } else {
                                //   logger.i(
                                //     "Video at index ${state.id} is now unsaved.",
                                //   );
                                // }
                              },
                            ),
                            Text(
                              actionsController.formatCount(state.savedCount!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 🔗 SHARE
                            IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () async {
                                final videoUrl = state.videoUrl;
                                if (videoUrl!.isEmpty) {
                                  await showCannotShareEmptyVideoDialog(
                                      context);
                                } else {
                                  // state.sharesCount = state.sharesCount! + 1;
                                  await SharePlus.instance.share(
                                    ShareParams(
                                      text: "🔥 Watch this video\n${videoUrl}",
                                      subject: "Check this video",
                                    ),
                                  );
                                  await actionsController.shareVideo(state);
                                }
                                // state.id.value,
                              },
                            ),
                            Text(
                              actionsController.formatCount(
                                  actionsController.sharesCount.value),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 10),
                          ],
                        );
                      });
                    },
                  ),
                ),

                /// 📝 CAPTION
                Positioned(
                  left: 12,
                  bottom: 40,
                  right: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.video.owner?.name ?? 'Unknown'}", // Use username from video data, or "Unknown" if null
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "${widget.video.caption}", // Use caption from video data, or empty string if null
                        style: TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/comments.dart';
import 'package:live_video_apps/app/modules/comments/comments/comments_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';
import 'package:live_video_apps/app/utils/messages.dart';
import 'package:logger/web.dart';

Logger logger = Logger();

class CommentSheet extends StatelessWidget {
  final String videoId;

  // final VideoController _video_controller = Get.put(VideoController());
  final CommentsController _commentController = Get.put(CommentsController());

  CommentSheet({super.key, required this.videoId}) {
    print("video from comment $videoId}");
  }
  @override
  void initState() {
    _initComment();
  }

  Future<void> _initComment() async {
    final _commentController = Get.find();
    await _commentController.getComments(videoId);
    // final videos = _actionsController.videosList[0].videos!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.7,
      color: Colors.white,
      child: Column(
        children: [
          const Text("Comments"),
          Expanded(
              child: (_commentController.commentList.isEmpty)
                  ? const Center(child: Text("No comments"))
                  : ListView.builder(
                      itemCount:
                          _commentController.commentList[0].comments!.length,
                      itemBuilder: (context, index) {
                        final c =
                            _commentController.commentList[0].comments![index];

                        return ListTile(
                          title: Text(c.user!.name!),
                          subtitle: Text(c.comment ?? ""),
                        );
                      },
                    )

              // ListView.builder(
              //   itemCount: _commentController.commentList[0].comments?.length,
              //   itemBuilder: (context, index) {
              //     if (_commentController.commentList.isEmpty) {
              //       return null;
              //     }

              //     final comments = _commentController.commentList[0].comments;

              //     var totalComments =
              //         _commentController.commentList[0].commentCount?.value;
              //     final topComments =
              //         comments!.where((c) => c.parent_id == null).toList();
              //     return const Text("1");

              //     // return Column(
              //     //   children: topComments.map((c) {
              //     //     return CommentTile(c: c);
              //     //   }).toList(),
              //     // );
              //     // ListView.builder(
              //     //   itemCount: _commentController.commentList[0].comments?.length,
              //     //   itemBuilder: (context, index) {
              //     //     final c = comments[index];

              //     // return CommentTile(c: topComments[index]);
              //     //   },
              //     // );
              //   },
              // ),
              ),
          TextField(
            // controller: controller.commentController,
            decoration: InputDecoration(
              hintText: "Add a comment",
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // _actionController.addComment();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CommentTile extends StatefulWidget {
  final Comments c;

  const CommentTile({super.key, required this.c});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool showReplies = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            c.user!.name!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(c.comment ?? ""),
          trailing: IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // like comment
            },
          ),
        ),

        /// Reply button
        if (c.replies != null && c.replies!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextButton(
              child: Text(
                showReplies
                    ? "Hide replies"
                    : "View ${c.replies!.length} replies",
              ),
              onPressed: () {
                setState(() {
                  showReplies = !showReplies;
                });
              },
            ),
          ),

        /// Replies
        if (showReplies)
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              children: c.replies!.map((r) {
                return ListTile(
                  title: Text(
                    r.user!.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: '${r.comment}\n'),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

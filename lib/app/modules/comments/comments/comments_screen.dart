import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:live_video_apps/app/data/models/comments.dart';
import 'package:live_video_apps/app/modules/comments/comments/comments_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_controller.dart';
import 'package:live_video_apps/app/utils/messages.dart';
import 'package:logger/web.dart';

Logger logger = Logger();

class CommentSheet extends StatefulWidget {
  final String videoId;

  const CommentSheet({super.key, required this.videoId});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final _commentController = Get.find<CommentsController>();

  @override
  void initState() {
    super.initState();
    initComments();
  }

  Future<void> initComments() async {
    await _commentController.getComments(widget.videoId);
  }

  @override
  Widget build(BuildContext context) {
    // final CommentsController _commentController = Get.put(CommentsController());

    // final _commentController = Get.find<CommentsController>();
    return Container(
      height: Get.height * 0.7,
      color: Colors.white,
      child: Column(
        children: [
          const Text("Comments"),
          Obx(() {
            if (_commentController.commentList.isEmpty ||
                _commentController.commentList[0] == null ||
                _commentController.commentList[0].comments == null ||
                _commentController.commentList[0].comments!.isEmpty) {
              print("Comment list is empty");
              return Center(child: Text("Comment list is empty"));
            }
            return Expanded(
                child: ListView.builder(
              itemCount: _commentController.commentList[0].comments?.length,
              itemBuilder: (context, index) {
                final c = _commentController.commentList[0].comments?[index];
                _commentController.videoID = widget.videoId;
                print("VideoID in ListView ${_commentController.videoID}");
                print("user Id: ${_commentController.user_id}");
                return CommentTile(c: c!);
              },
            ));
          }),
          Form(
            key: _commentController.createCommmentKeyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _commentController.comment,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Svp veuillez remplir le champs";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.comment,
                      // color: Color.fromARGB(255, 0, 173, 253),
                    ),
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 173, 253),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Add a comment",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        var userId = _commentController.user_id;
                        print("Videos id: ${widget.videoId}, User : ${userId}");
                        _commentController.videoID = widget.videoId;
                        _commentController.addComment();

                        print(
                            "CommentList ${_commentController.commentList[0].commentCount}");
                        _commentController.comment.clear();
                      },
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
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
  // final controller = Get.find<CommentsController>();

  @override
  Widget build(BuildContext context) {
    var commentController = Get.find<CommentsController>();
    final c = widget.c;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetBuilder<CommentsController>(builder: (controller) {
          final isReplying = controller.parentID == c.id;

          return ListTile(
              title: Text(
                c.user!.name!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                // 👈 CHANGE THIS (important)
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.comment ?? ""),

                  /// 🔥 REPLY BUTTON (ADD HERE)
                  TextButton(
                    onPressed: () {
                      commentController.openReply(c.id!);
                    },
                    child: Text("Reply"),
                  ),

                  /// 🔥 REPLY FORM (SHOW ONLY IF CLICKED)
                  if (isReplying)
                    ReplyForm(
                      commentId: c.id!,
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🗑️ DELETE / REPORT
                  IconButton(
                    icon: Icon(
                      (commentController.user_id! == c.user_id)
                          ? Icons.delete
                          : Icons.report,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (commentController.user_id! == c.user_id) {
                        // delete comment
                        commentController.deleteComment(c);
                      } else {
                        // report comment
                        print("Report comment ${c.id}");
                      }
                    },
                  ),

                  const SizedBox(width: 4), // 👈 spacing

                  /// ❤️ LIKE BUTTON + COUNT
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: Icon(
                          c.isLiked.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          controller.toggleLike(c);
                        },
                      ),

                      /// 🔢 LIKE COUNT BADGE
                      if (c.likeCount.value > 0)
                        Positioned(
                          right: 5,
                          top: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${c.likeCount.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ));
        }),

        /// Reply button
        if (c.replies != null && c.replies!.isNotEmpty)
          Obx(() {
            return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    TextButton(
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
                  ],
                ));
          }),

        /// Replies
        if (showReplies)
          Obx(() {
            return Padding(
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// 🗑️ DELETE / REPORT
                        IconButton(
                          icon: Icon(
                            (commentController.user_id! == r.user_id)
                                ? Icons.delete
                                : Icons.report,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            if (commentController.user_id! == r.user_id) {
                              // delete reply
                              commentController.deleteReply(r);
                            } else {
                              // report reply
                              print("Report reply ${r.id}");
                            }
                          },
                        ),

                        const SizedBox(width: 4), // 👈 spacing

                        // ❤️ LIKE BUTTON + COUNT
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              icon: Icon(
                                r.isLiked!.value //r.isLiked!.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                //like reply
                                commentController.toggleLikeReplies(r);
                              },
                            ),

                            /// 🔢 LIKE COUNT BADGE
                            if (r.likeCount!.value > 0) //r.likeCount!.value > 0
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${r.likeCount!.value}', //${r.likeCount!.value}
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }),
      ],
    );
  }
}

class ReplyForm extends StatefulWidget {
  final String commentId;

  const ReplyForm({super.key, required this.commentId});

  @override
  State<ReplyForm> createState() => _ReplyFormState();
}

class _ReplyFormState extends State<ReplyForm> {
  // final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final commentsController = Get.find<CommentsController>();

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Row(children: [
        Expanded(
            child: Form(
          key: commentsController.createReplyKeyForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: commentsController.comment,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Svp veuillez remplir le champs";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.comment,
                  ),
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 173, 253),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Reply",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      print("Reply to this comment ${widget.commentId}");
                      commentsController.addReply(widget.commentId);
                      commentsController.comment.clear();
                    },
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ))
      ]),
    );
  }
}

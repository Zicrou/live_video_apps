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
            )
                // ListView.builder(
                //   itemCount: _commentController.commentList[0].comments!.length,
                //   itemBuilder: (context, index) {
                //     final comments =
                //         _commentController.commentList[0].comments![index];
                //     // return Column(
                //     //   children: comments!.map((c) {
                //     return CommentTile(c: comments);
                //     //   }).toList(),
                //     // );

                //     //     return ListTile(
                //     //       title: Text(c.user!.name!),
                //     //       subtitle: Text(c.comment ?? ""),
                //     //     );
                //     //   },
                //     // )

                //     // ListView.builder(
                //     //   itemCount: _commentController.commentList[0].comments?.length,
                //     //   itemBuilder: (context, index) {
                //     //     // if (_commentController.commentList.isEmpty) {
                //     //     //   return null;
                //     //     // }

                //     //     final comments = _commentController.commentList[0].comments;

                //     //     // var totalComments =
                //     //     //     _commentController.commentList[0].commentCount?.value;
                //     //     // final topComments =
                //     //     //     comments!.where((c) => c.parent_id == null).toList();
                //     //     // return const Text("1");

                //     // return Column(
                //     //   children: topComments.map((c) {
                //     //     return CommentTile(c: c);
                //     //   }).toList(),
                //     // );

                //   },
                // ),
                );
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
                    // errorText: controller.isDesignationValid.value
                    //     ? null
                    //     : "Désignation invalide",
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
                        print(
                            "Videos id: ${_commentController.videoID}, User : ${userId}");
                        _commentController.addComment();
                        _commentController.comment.clear();
                      },
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                // TextFormField(
                //   controller: _commentController.comment,
                //   decoration: InputDecoration(
                //     hintText: "Add a comment",
                //     suffixIcon: IconButton(
                //       icon: Icon(Icons.send),
                //       onPressed: () {
                //         _commentController.addComment();
                //       },
                //     ),
                //   ),
                // )
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
    final c = widget.c;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return ListTile(
              title: Text(
                c.user!.name!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(c.comment ?? ""),
              trailing: IconButton(
                icon: Icon(
                  c.isLiked.value ? Icons.favorite : Icons.favorite_border,
                  color: Colors.black,
                  // size: 32,
                ),
                onPressed: () {
                  // like comment
                  print("Like this comment ${c.id}");
                  if (CommentsController().toggleLike(c) == true) {
                    c.isLiked.value = true;
                  }
                },
              ));
        }),

        /// Reply button
        if (c.replies != null && c.replies!.isNotEmpty)
          Obx(() {
            return Padding(
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
            );
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
                  );
                }).toList(),
              ),
            );
          })
      ],
    );
  }
}

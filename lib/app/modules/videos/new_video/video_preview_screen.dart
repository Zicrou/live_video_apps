import 'dart:io';
import 'package:flutter/material.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class VideoPreviewScreen extends StatefulWidget {
  final File? videoFile;
  const VideoPreviewScreen({super.key, this.videoFile});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _controller;
  VideoController video_controller = Get.put(VideoController());
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoFile?.path ?? ""))
      ..initialize().then((_) {
        setState(() {
          isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    final video = Get.arguments;
    // video_controller.video_url.text = video_controller.selectedVideo.value;
    // print("Video: ${video_controller.video_url.text.trim()}");
    // print("Selected file: ${video_controller.selectedVideo.value!.path}");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Preview"),
      ),
      body: Column(
        children: [
          /// VIDEO PREVIEW
          Expanded(
            child: Center(
              child: isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),

                        // Pause/Play overlay button
                        GestureDetector(
                          onTap: () {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          },
                          child: Container(
                            color: Colors.transparent, // Detect taps anywhere
                            alignment: Alignment.center,
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              size: 64,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const CircularProgressIndicator(),
            ),
          ),

          /// CAPTION INPUT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: video_controller.createVideoKeyForm,
              // controller.videos.id != null
              //     ? controller.updateProduitKeyForm
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: video_controller.caption,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Write a caption...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  // TextFormField(
                  //   controller: video_controller.video_url,
                  //   decoration: InputDecoration(
                  //     prefixIcon: Icon(
                  //       Icons.video_file,
                  //       color: Color.fromARGB(255, 0, 173, 253),
                  //     ),
                  //     labelText: "Video Url",
                  //     labelStyle: TextStyle(
                  //       color: Color.fromARGB(255, 0, 173, 253),
                  //     ),
                  //     // errorText: controller.isPrixValid.value
                  //     //     ? null
                  //     //     : "Prix invalide",
                  //     filled: true,

                  //     fillColor: Colors.white,
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  //   obscureText: false,
                  //   keyboardType: TextInputType.text,
                  // ),
                  // SizedBox(height: 20),

                  /// POST BUTTON
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        print("Caption: ${video_controller.caption}");

                        print("Video Url: ${video_controller.video_url}");
                        video_controller.createVideo();
                      },
                      child: const Text("Post Video"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

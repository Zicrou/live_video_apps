import 'dart:io';
import 'package:flutter/material.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class VideoPreviewScreen extends StatefulWidget {
  final File videoFile;
  const VideoPreviewScreen({super.key, required this.videoFile});

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

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoFile.path))
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
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Preview"),
      ),

      body: Column(
        children: [
          /// VIDEO PREVIEW
          // video_controller.video_url.value = widget.videoFile.path
          Expanded(
            child: Center(
              child: isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
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
                  TextFormField(
                    controller: video_controller.video_url,

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.video_file,
                        color: Color.fromARGB(255, 0, 173, 253),
                      ),
                      labelText: "Video Url",
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 173, 253),
                      ),
                      // errorText: controller.isPrixValid.value
                      //     ? null
                      //     : "Prix invalide",
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
                    ),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 20),

                  /// POST BUTTON
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        print("Caption: ${video_controller.caption}");
                        print("Caption: ${video_controller.video_url}");
                        // video_controller.createVideo();
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

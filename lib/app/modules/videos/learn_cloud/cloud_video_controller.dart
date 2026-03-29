import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:live_video_apps/app/data/models/videoActionState.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';
import 'package:live_video_apps/app/data/services/remote_services.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_preview_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_screen.dart';
import 'package:live_video_apps/app/utils/messages.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

Logger logger = Logger();

class CloudVideoController extends GetxController {
  var isLoading = true.obs;
  final RemoteServices remoteService = Get.find<RemoteServices>();
  // VideosRepositories _videosRepositories = VideosRepositories();
  static final Dio _dio = Dio();

  Future<void> fetchVideosfromCloud() async {
    final response = await _dio.get('http://13.220.86.245/api/videos');
  }
}

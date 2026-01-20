import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/data/models/live.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/services/auth_services.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/app/utils/messages.dart';
import 'package:live_video_apps/pages/home_page.dart';
import 'package:live_video_apps/services/api_services.dart';
import 'package:logger/web.dart';

Logger logger = Logger();

class Uploadscontroller extends GetxController {
  ApiServices apiService = ApiServices();
  final userToken = "";
  RxList<Live> lives = <Live>[].obs;
  @override
  void onInit() {
    super.onInit();
    // uploadVideos();
  }

  // Future<void> uploadVideos() async {
  //   logger.i("Uploading videos ...");
  //   const token = "13|fqsMBlQk3cuJKLutkIdvSzJ2GKrqQzXTitGSWJ5v2ea8aa7d";
  //   FormData formData = FormData.fromMap({
  //     // "caption": caption,
  //     "video": await MultipartFile.fromFile(picked.path, filename: picked.name),
  //   });
  //   var dataPosted;
  //   try {
  //     logger.i('Form Data: ${baseUrl}/upload-video}');
  //     dataPosted = await Dio().post(
  //       "${baseUrl}/upload-video",
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $token",
  //           "Content-Type": "multipart/form-data",
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     logger.e('Error uploading video: ${e.toString()}');
  //   }
  //   logger.i('Upload response: ${dataPosted}');
  //   var response = await apiService.upload_videos(userToken);
  //   // lives.value = response;
  //   lives.assignAll(response);

  //   logger.i("Response List Lives fetched: $lives");
  // }

  // Future<void> storeLive() async {
  //   logger.i("Storing live for host ...");
  //   var response = await apiService.storeLives(userToken);

  //   logger.i("Response Store Live: $response");

  //   // AuthController authController = Get.find<AuthController>();
  //   // token = await ApiService.getHostToken(
  //   //   userToken,
  //   // ); // UserToken
  // }

  // Future<void> startLive() async {
  //   logger.i("Starting live for host ...");
  //   final live = await apiService.startLives(userToken);
  //   //"007eJxTYIj0iv3QXsbwrer7022X9Gas/TdTzGPJFlUf3wpm928MX1MUGAwNzBMtDc1NDI3SEk0sE80tjSxMLE2NjCxNTJOTUsyNtm03zWwIZGRQSclgZWSAQBCfhyEjv7gkPjkjMS8vNYeBAQBnFyIV"; //

  //   _engine = createAgoraRtcEngine();
  //   await _engine.initialize(RtcEngineContext(appId: ApiServices.appId));

  //   // await _engine.initialize(
  //   //   const RtcEngineContext(appId: "107a917412fa49a792849522945cbd72"),
  //   // );

  //   await _engine.enableVideo();
  //   await _engine.startPreview();

  //   _engine.registerEventHandler(
  //     RtcEngineEventHandler(onJoinChannelSuccess: (c, uid) {}),
  //   );

  //   await _engine.joinChannel(
  //     token: live.data['liveToken'],
  //     channelId: live.data['channel_name'],
  //     uid: 0,
  //     options: const ChannelMediaOptions(
  //       clientRoleType: ClientRoleType.clientRoleBroadcaster,
  //     ),
  //   );

  //   _initialized.value = true;
  // }
}

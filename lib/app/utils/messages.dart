import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/core/values/app_colors.dart';
import 'package:live_video_apps/app/core/values/dimens.dart';

errorMessage(String textMsg) {
  Get.snackbar(
    'Message',
    textMsg,
    colorText: AppColors.whiteColor,
    backgroundColor: AppColors.errorColor,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 3),
    icon: Icon(Icons.error_outline, color: AppColors.whiteColor, size: 20),
  );
}

goodMessage(String textMsg) {
  Get.snackbar(
    'Message',
    textMsg,
    colorText: AppColors.whiteColor,
    backgroundColor: AppColors.primaryColor,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 5),
    icon: Icon(
      Icons.notifications_active_outlined,
      color: AppColors.whiteColor,
      size: Dimens.x4lSize,
    ),
  );

  // Get.snackbar(
  //   "",
  //   "",
  //   titleText: Text(
  //     "Failed",
  //     style: TextStyle(
  //       fontSize: 20,
  //       color: Colors.white,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   ),
  //   messageText: Text(
  //     textMsg,
  //     style: TextStyle(
  //       fontSize: 18, // 🔹 bigger font for message
  //       color: AppColors.whiteColor,
  //     ),
  //   ),
  //   backgroundColor: AppColors.errorColor,
  //   snackPosition: SnackPosition.TOP,
  //   duration: Duration(seconds: 3),
  //   icon: Icon(Icons.error_outline, color: AppColors.whiteColor, size: 20),
  // );
}

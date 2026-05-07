import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_apps/app/modules/login/login_screen.dart';
import 'package:live_video_apps/utilites/dialogs/generic_dialog.dart';

Future<void> showShouldGetConnectedDialog(BuildContext context, String action) {
  return showGenericDialog<void>(
      context: context,
      title: 'Connection Required',
      content: "You need to be connected to $action a video",
      optionsBuilder: () => {
            'Cancel': null,
            'Login': 'login',
          });
}

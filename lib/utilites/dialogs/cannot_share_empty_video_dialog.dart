import 'package:flutter/material.dart';
import 'package:live_video_apps/utilites/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyVideoDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: "You can not share an empty video",
    optionsBuilder: () => {
      'OK': null,
    }
  );
}

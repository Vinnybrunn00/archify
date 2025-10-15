import 'dart:io';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:archify/constants/constants_color.dart';
import 'package:archify/core/models/file_types.dart';

class Utils {
  static Widget? leading(
    FileSystemEntityType statsType,
    File file,
    FileTypes fileTypes,
  ) {
    switch (statsType) {
      case FileSystemEntityType.file:
        if (fileTypes.isAudio) {
          return Icon(
            EvaIcons.music_outline,
            color: AppColor.pupleColor,
            size: 22,
          );
        }

        if (fileTypes.isVideo) {
          return Icon(
            EvaIcons.video_outline,
            color: AppColor.pupleColor,
            size: 22,
          );
        }

        if (fileTypes.isText) {
          return Icon(
            EvaIcons.text_outline,
            color: AppColor.pupleColor,
            size: 22,
          );
        }
        if (fileTypes.isPdf) {
          return Icon(
            FontAwesome.file_pdf,
            color: AppColor.pupleColor,
            size: 19,
          );
        }
      case FileSystemEntityType.directory:
        return Icon(
          Icons.folder_outlined,
          color: AppColor.pupleColor,
          size: 22,
        );
      default:
        return Icon(
          EvaIcons.question_mark,
          color: AppColor.pupleColor,
          size: 22,
        );
    }
    return Icon(Icons.file_open_outlined, color: AppColor.pupleColor, size: 22);
  }
}

import 'dart:io';

import 'package:archify/constants/constants_color.dart';
import 'package:archify/constants/constants_regex.dart';
import 'package:archify/core/models/file_types.dart';
import 'package:archify/ui/page/main_page.dart';
import 'package:archify/ui/view/app_pdf_view.dart';
import 'package:archify/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class FilesDirectoryManager with ChangeNotifier {
  final FileSystemEntity _fileEntity;

  FilesDirectoryManager({required FileSystemEntity fileEntity})
    : _fileEntity = fileEntity;

  final Utils _utils = Utils();

  String get path => _fileEntity.path;

  String get nameFile => path.split('/').last;

  Directory get _directory => Directory(path);
  File get _file => File(path);

  FileStat get _fileStat => _file.statSync();
  FileStat get _dicStats => _directory.statSync();

  FileSystemEntityType get _dicType => _dicStats.type;

  bool get isDirectory => _dicType == FileSystemEntityType.directory;

  DateTime get modified => _fileStat.modified;
  int get size => _fileStat.size;

  List<String> get _splitFiles => path.split('/com.vindev.archify/files');

  FileTypes get fileTypes => FileTypes(
    isImage: imageExtensions.hasMatch(path),
    isPdf: pdfExtRegex.hasMatch(path),
    isVideo: videoExtRegex.hasMatch(path),
    isAudio: audioExtRegex.hasMatch(path),
    isText: textExtRegex.hasMatch(path),
    isCode: codeExtRegex.hasMatch(path),
  );

  void openFilesAndFolder(BuildContext context) {
    // open folder
    if (isDirectory) {
      _utils.goToRoutePageWithOutAnimation(
        context,
        route: MainPage(
          path: path,
          name: nameFile,
          splitFiles: _splitFiles,
          listItems: _directory.listSync(),
        ),
      );
    }

    // open PDF file (only android)
    if (fileTypes.isPdf) {
      _utils.goToRoutePageWithOutAnimation(
        context,
        route: PdfViewer(path: path),
      );
    }
  }

  Widget? leading() {
    switch (_dicType) {
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

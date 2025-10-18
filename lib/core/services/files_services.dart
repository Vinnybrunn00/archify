import 'dart:developer';
import 'dart:io';

import 'package:archify/core/services/app_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FilesServices {
  final AppServices _appServices = AppServices();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> onShareOnlyFile(String path, String nameFile) async {
    final ShareParams params = ShareParams(
      text: nameFile,
      files: [XFile(path)],
    );

    await SharePlus.instance.share(params);
  }

  Future<void> renameFileOrFolder({
    required String path,
    required String newName,
    required bool isDirectory,
  }) async {
    try {
      final String extension = path.split('.').last;

      final Directory directory = Directory(path);
      final File file = File(path);

      String directoryPath = directory.parent.path;
      String filePath = file.parent.path;

      final String newPath = isDirectory
          ? '$directoryPath/$newName'
          : '$filePath/$newName.$extension';

      isDirectory
          ? await directory.rename(newPath)
          : await file.rename(newPath);
    } catch (err) {
      log(err.toString());
    }
  }

  Future<void> onSelectAndCopyFile(String? path) async {
    final Directory? directory = await getDownloadsDirectory();
    if (directory == null) return;

    try {
      String pathTo = path ?? directory.parent.path;

      final FilePickerResult? filePicker = await FilePicker.platform
          .pickFiles();

      if (filePicker != null) {
        final PlatformFile file = filePicker.files.single;

        if (file.path != null) {
          await _appServices.copyFiles(
            name: file.name,
            fromPath: file.path!,
            toPath: pathTo,
          );
        }
      }
    } catch (_) {
      _errorMessage = 'Erro ao selecionar ou mover arquivo';
    }
  }
}

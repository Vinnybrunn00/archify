import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AppServices {
  void createFolder(String newFolder, String? path) async {
    final Directory? directory = await getDownloadsDirectory();

    if (directory != null) {
      final String files = directory.parent.path;

      String joinPath = path ?? files;

      final Directory dicFiles = Directory('$joinPath/$newFolder');

      await dicFiles.create();
    }
  }

  Future<void> delete(String path) async {
    final Directory directory = Directory(path);
    await directory.delete(recursive: true);
  }

  List<FileSystemEntity> listFolders(String path) {
    final Directory dicFiles = Directory(path);
    return dicFiles.listSync();
  }

  void copyFiles({
    required String fromPath,
    required String toPath,
    required String name,
  }) async {
    final File file = File(fromPath);
    await file.copy('$toPath/$name');
  }
}

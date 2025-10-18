import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AppServices {
  Future<String?> createFolder(String newFolder, String? path) async {
    final Directory? directory = await getDownloadsDirectory();

    if (directory != null) {
      final String files = directory.parent.path;

      String joinPath = path ?? files;

      Directory dicFiles = Directory('$joinPath/$newFolder');

      if (await dicFiles.exists()) {
        return 'Uma pasta com este nome ja existe, tente outro.';
      }

      await dicFiles.create();
      return null;
    }
    return 'Diretório não existe!';
  }

  Future<void> delete(String path) async {
    final Directory directory = Directory(path);
    await directory.delete(recursive: true);
  }

  List<FileSystemEntity> listFolders(String path) {
    final Directory dicFiles = Directory(path);
    return dicFiles.listSync();
  }

  Future<void> copyFiles({
    required String fromPath,
    required String toPath,
    required String name,
  }) async {
    final File file = File(fromPath);
    await file.copy('$toPath/$name');
  }
}

import 'dart:developer';
import 'dart:io';
import 'package:archify/core/services/interfaces/file_service_interface.dart';
import 'package:archify/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FilesServices implements FileServiceInterface {
  final Utils _utils = Utils();

  String? _errorMessage;

  @override
  String? get errorMessage => _errorMessage;

  @override
  Future<void> onShareOnlyFile(String path, String nameFile) async {
    final ShareParams params = ShareParams(
      text: nameFile,
      files: [XFile(path)],
    );

    await SharePlus.instance.share(params);
  }

  @override
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
    } on FileSystemException catch (err) {
      _errorMessage = _utils.showFileSystemException(err.message);
    }
  }

  @override
  Future<String?> createFolder(String newFolder, String? path) async {
    final Directory? directory = await getDownloadsDirectory();

    if (directory == null) return 'Diretório não existe!';

    try {
      final String files = directory.parent.path;

      String joinPath = path ?? files;

      Directory dicFiles = Directory('$joinPath/$newFolder');

      if (await dicFiles.exists()) {
        return 'Uma pasta com este nome ja existe, tente outro.';
      }

      await dicFiles.create();
      return null;
    } on FileSystemException catch (err) {
      return _utils.showFileSystemException(err.message);
    }
  }

  @override
  Future<void> delete(String path) async {
    try {
      final Directory directory = Directory(path);
      await directory.delete(recursive: true);
    } on FileSystemException catch (err) {
      _errorMessage = _utils.showFileSystemException(err.message);
    }
  }

  @override
  List<FileSystemEntity> listFolders(String path) {
    final Directory dicFiles = Directory(path);
    return dicFiles.listSync();
  }

  @override
  Future<void> onSelectAndCopyFile(String? path) async {
    final Directory? directory = await getDownloadsDirectory();
    if (directory == null) return;

    try {
      String pathTo = path ?? directory.parent.path;

      final FilePickerResult? pickFiles = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if (pickFiles != null) {
        final List<File> fileList = pickFiles.paths
            .map((paths) => File(paths!))
            .toList();

        for (final File item in fileList) {
          String name = item.path.split('/').last;
          await item.copy('$pathTo/$name');
        }
      }
    } catch (err) {
      _errorMessage = 'Erro ao selecionar ou mover arquivo';
    }
  }
}

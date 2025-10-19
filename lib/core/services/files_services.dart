import 'dart:developer';
import 'dart:io';
import 'package:archify/core/services/interfaces/interface_file_service.dart';
import 'package:archify/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FilesServices implements InterfaceFileService {
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

    if (directory != null) {
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
    return 'Diretório não existe!';
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

      final FilePickerResult? filePicker = await FilePicker.platform
          .pickFiles();

      if (filePicker != null) {
        final PlatformFile fileSingle = filePicker.files.single;

        if (fileSingle.path != null) {
          final File file = File(fileSingle.path!);
          await file.copy('$pathTo/${fileSingle.name}');
        }
      }
    } catch (err) {
      log(err.toString());
      _errorMessage = 'Erro ao selecionar ou mover arquivo';
    }
  }
}

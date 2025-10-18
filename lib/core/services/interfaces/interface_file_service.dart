import 'dart:io';

abstract class InterfaceFileService {
  String? get errorMessage;

  Future<void> renameFileOrFolder({
    required String path,
    required String newName,
    required bool isDirectory,
  });

  Future<void> onShareOnlyFile(String path, String nameFile);

  Future<String?> createFolder(String newFolder, String? path);

  Future<void> delete(String path);

  List<FileSystemEntity> listFolders(String path);

  Future<void> onSelectAndCopyFile(String? path);
}

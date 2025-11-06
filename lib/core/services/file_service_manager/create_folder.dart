import 'dart:io';
import 'package:archify/core/contracts/message_error_interface.dart';
import 'package:path_provider/path_provider.dart';

/// This class handles folder creation inside a specified path or,
/// It also maps system-level file exceptions into user-friendly messages.
class CreateFolderManager implements MessageErrorInterface {
  /// The path where the new folder will be created.
  String? path;

  /// The name of the new folder to be created.
  String newFolder;

  /// Creates an instance of [CreateFolderManager].
  ///
  /// The [path] parameter defines the target directory.
  /// The [newFolder] parameter specifies the folder name to be created.
  CreateFolderManager({required this.path, required this.newFolder});

  /// The error message property from [MessageErrorInterface].
  ///
  /// It will never be implemented because error handling is delegated.
  /// to [showFileSystemException].
  @override
  String? get errorMessage => throw UnimplementedError();

  /// Maps a [FileSystemException] message into a user-friendly message.
  ///
  /// Returns a Portuguese description for common filesystem errors.
  /// If the message does not match a known case, returns `'Invalid argument'`.
  @override
  String showFileSystemException(String message) {
    switch (message) {
      case 'Not a directory':
        return 'Isso não é um diretório';
      case 'Permission denied':
        return 'Você não tem permissão para executar esta ação';
      case 'Device or resource busy':
        return 'Dispositivo ou recurso ocupado';
      case 'No space left on device':
        return 'Não há espaço disponível no dispositivo';
      default:
        return 'Invalid argument';
    }
  }

  /// Creates a new folder in the filesystem.
  ///
  /// Possible error cases include:
  /// - The base directory does not exist.
  /// - A folder with the same name already exists.
  /// - Filesystem access or permission issues (handled by [showFileSystemException]).
  Future<String?> create() async {
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
      return showFileSystemException(err.message);
    }
  }
}

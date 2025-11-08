import 'dart:io';
import 'package:archify/core/contracts/message_error_interface.dart';
import 'package:path_provider/path_provider.dart';

/// This class handles folder creation inside a specified path or,
class CreateFolderManager implements MessageErrorInterface {
  /// The path where the new folder will be created.
  String? path;

  /// The name of the new folder to be created.
  String newFolder;

  String? _errorMessage;

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
  String? get errorMessage => _errorMessage;

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
  Future<void> create() async {
    final Directory? directory = await getDownloadsDirectory();

    if (directory == null) {
      _errorMessage = 'Diretório não existe!';
      return;
    }

    try {
      final String files = directory.parent.path;

      String joinPath = path ?? files;

      Directory dicFiles = Directory('$joinPath/$newFolder');

      if (await dicFiles.exists()) {
        _errorMessage = 'Uma pasta com este nome ja existe, tente outro.';
        return;
      }
      await dicFiles.create();
      _errorMessage = null;
    } on FileSystemException catch (err) {
      _errorMessage = showFileSystemException(err.message);
    }
  }
}

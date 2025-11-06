import 'dart:io';
import 'package:archify/core/contracts/message_error_interface.dart';

/// This class handles renaming operations for both files and directories,
/// providing detailed error handling through [MessageErrorInterface].
class RenameFileFolder implements MessageErrorInterface {
  /// The current full path of the file or folder to be renamed.
  String path;

  /// The new name to assign to the file or folder.
  ///
  /// For files, the original extension will be automatically appended.
  String newName;

  /// Indicates whether the target is a directory (`true`) or a file (`false`).
  bool isDirectory;

  /// Creates an instance of [RenameFileFolder].
  ///
  /// The [path] parameter specifies the current file or folder location,
  /// [newName] defines the new name, and [isDirectory] determines
  /// whether the operation applies to a directory or file.
  RenameFileFolder({
    required this.path,
    required this.newName,
    required this.isDirectory,
  });

  // Stores the most recent error message, if any.
  String? _errorMessage;

  /// Returns the last recorded error message, or `null` if no error occurred.
  @override
  String? get errorMessage => _errorMessage;

  /// Converts raw filesystem exception messages into
  /// user-friendly Portuguese messages.
  ///
  /// Provides readable explanations for common filesystem-related
  /// rename errors, and defaults to `'Invalid argument'` when unknown.
  @override
  String showFileSystemException(String message) {
    switch (message) {
      case 'Cannot rename file' || 'Rename failed':
        return 'Arquivo não pode ser renomeado';
      case 'Not a directory':
        return 'Isso não é um diretório';
      case 'File exists':
        return 'Arquivo existente.';
      case 'No such file or directory':
        return 'Não existe tal arquivo ou diretório';
      case 'Permission denied':
        return 'Você não tem permissão para executar esta ação';
      case 'Device or resource busy':
        return 'Dispositivo ou recurso ocupado';
      default:
        return 'Invalid argument';
    }
  }

  /// Renames the target file or folder.
  ///
  /// - If [isDirectory] is `true`, the class treats [path] as a directory.
  /// - If `false`, the file’s extension is preserved automatically.
  ///
  /// In case of a [FileSystemException], the error message is processed
  /// and stored in [_errorMessage] using [showFileSystemException].
  Future<void> rename() async {
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
      _errorMessage = showFileSystemException(err.message);
    }
  }
}

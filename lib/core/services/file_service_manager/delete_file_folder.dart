import 'dart:io';
import 'package:archify/core/contracts/message_error_interface.dart';

/// This class handles both file and directory deletion operations.
class DeleteFileFolder implements MessageErrorInterface {
  /// The full path of the file or folder to be deleted.
  String path;

  /// Creates an instance of [DeleteFileFolder].
  ///
  /// The [path] parameter must point to a valid file or directory.
  DeleteFileFolder({required this.path});

  /// Stores the most recent error message, if any, during deletion.
  String? _errorMessage;

  /// Returns the last error message captured during a delete operation,
  /// or `null` if no error occurred.
  @override
  String? get errorMessage => _errorMessage;

  /// Converts low-level filesystem exception messages into
  /// human-readable Portuguese descriptions.
  ///
  /// If the provided [message] does not match a known case,
  /// the default value `'Invalid argument'` is returned.
  @override
  String showFileSystemException(String message) {
    switch (message) {
      case 'Cannot delete file':
        return 'Arquivo não pode ser deletado';
      case 'Cannot delete directory':
        return 'Pasta não pode ser deletada';
      case 'Permission denied':
        return 'Você não tem permissão para executar esta ação';
      case 'Device or resource busy':
        return 'Dispositivo ou recurso ocupado';
      case 'Text file busy':
        return 'Arquivo de texto ocupado';
      default:
        return 'Invalid argument';
    }
  }

  /// Deletes the file or directory specified by [path].
  ///
  /// If the target is a directory, it will be deleted recursively,
  /// removing all its contents as well.
  ///
  /// In case of a [FileSystemException], the error message is
  /// processed using [showFileSystemException] and stored in [_errorMessage].
  Future<void> delete() async {
    try {
      final Directory directory = Directory(path);
      await directory.delete(recursive: true);
    } on FileSystemException catch (err) {
      _errorMessage = showFileSystemException(err.message);
    }
  }
}

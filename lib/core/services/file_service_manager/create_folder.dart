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
        return 'This is not a directory.';
      case 'Permission denied':
        return 'You do not have permission to perform this action.';
      case 'Device or resource busy':
        return 'Busy device or resource';
      case 'No space left on device':
        return 'There is no space available on the device.';
      default:
        return 'Unknown error';
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
      _errorMessage = 'Directory doesn"t exist';
      return;
    }

    try {
      final String files = directory.parent.path;

      String joinPath = path ?? files;

      Directory dicFiles = Directory('$joinPath/$newFolder');

      if (await dicFiles.exists()) {
        _errorMessage = 'A folder with this name already exists.';
        return;
      }

      await dicFiles.create();
      _errorMessage = null;
    } on FileSystemException catch (err) {
      _errorMessage = showFileSystemException(err.message);
    }
  }
}

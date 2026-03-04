import 'dart:io';
import 'package:share_plus/share_plus.dart';

/// A service class responsible for handling file-related operations
/// such as sharing and listing directory contents.
///
/// This service is designed to work with local storage files
/// and integrates with the [`share_plus`](https://pub.dev/packages/share_plus)
/// package to allow native file sharing.
///
/// It provides:
/// - The ability to share a specific file with its name.
/// - The ability to list files and folders within a given directory.
class FilesServices {
  /// Shares a single file using the native sharing interface.
  ///
  /// This method uses the `share_plus` package to open the system’s
  /// share dialog and send the selected file to other applications.
  ///
  /// Parameters:
  /// - [path]: The full path to the file to be shared.
  /// - [nameFile]: The name of the file to be shown in the share dialog.
  ///
  /// Example:
  /// ```dart
  /// await filesServices.onShareOnlyFile('/storage/emulated/0/Downloads/file.txt', 'file.txt');
  /// ```
  Future<void> onShareOnlyFile(String path, String nameFile) async {
    final ShareParams params = ShareParams(
      text: nameFile,
      files: [XFile(path)],
    );

    await SharePlus.instance.share(params);
  }

  /// Lists all files and folders within the specified directory path.
  ///
  /// Returns a [List] of [FileSystemEntity] objects representing
  /// the directory’s contents, including files and subdirectories.
  ///
  /// Throws a [FileSystemException] if the directory does not exist
  /// or cannot be accessed.
  List<FileSystemEntity> listFolders(String path) {
    final Directory dicFiles = Directory(path);
    final List<FileSystemEntity> entities = dicFiles.listSync();

    entities.sort((FileSystemEntity a, FileSystemEntity b) {
      final DateTime aDate = a.statSync().modified;
      final DateTime bDate = b.statSync().modified;
      return bDate.compareTo(aDate);
    });
    return entities;
  }
}

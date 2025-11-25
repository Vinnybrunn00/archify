import 'dart:io';
import 'package:archify/core/contracts/message_error_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

/// This class allows users to select multiple files using the native file picker
/// and copy them to a target folder.
class SelectCopyFile implements MessageErrorInterface {
  /// The destination path where the selected files will be copied.
  String? path;

  /// Creates an instance of [SelectCopyFile].
  /// The [path] parameter defines the destination folder for the copied files.
  SelectCopyFile({required this.path});

  // Stores the most recent error message, if any.
  String? _errorMessage;

  /// Returns the latest error message captured during the copy process,
  /// or `null` if no error occurred.
  @override
  String? get errorMessage => _errorMessage;

  /// [showFileSystemException] will never be used in this class
  @override
  String showFileSystemException(String message) => throw UnimplementedError();

  // Opens a file picker to select one or more files, then copies them
  // to the specified directory.
  Future<void> onSelectAndCopy() async {
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

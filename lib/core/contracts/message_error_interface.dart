/// A base interface that defines a standard structure for handling
/// file system–related errors and exposing error messages.
///
/// Classes that implement this interface are expected to:
/// - Provide a getter for retrieving the last recorded error message.
/// - Implement a method to convert low-level system exceptions into
///   human-readable error messages.
///
/// This design enforces consistent error handling across
/// multiple file or directory management classes.
///
/// Example implementation:
/// ```dart
/// class FileManager implements MessageErrorInterface {
///   String? _errorMessage;
///
///   @override
///   String? get errorMessage => _errorMessage;
///
///   @override
///   String showFileSystemException(String message) {
///     switch (message) {
///       case 'Permission denied':
///         return 'You do not have permission to perform this action.';
///       default:
///         return 'An unknown file system error occurred.';
///     }
///   }
/// }
/// ```
abstract class MessageErrorInterface {
  /// Returns the most recent error message, if one exists.
  ///
  /// Typically used after a failed file system operation
  /// to retrieve the user-friendly error description.
  String? get errorMessage;

  /// Converts a low-level [FileSystemException] message
  /// into a human-readable format.
  ///
  /// Implementations should handle specific error cases and
  /// provide localized or user-friendly feedback.
  String showFileSystemException(String message);
}

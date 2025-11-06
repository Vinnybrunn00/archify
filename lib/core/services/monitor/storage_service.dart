import 'package:flutter/services.dart';

/// A service responsible for retrieving and streaming
/// storage information from the native Android layer.
///
/// This class communicates through a [MethodChannel] with
/// identifier `'archify/device_info'`, invoking the native
/// method `'getStorageInfo'` to obtain data about the device’s
/// internal and external storage (e.g., total, used, and free space).
///
/// The information is exposed as a [Stream] that emits updates
/// every second, making it suitable for real-time storage monitoring.
class StorageService {
  /// The [MethodChannel] used to communicate with the native layer.
  final MethodChannel _device = const MethodChannel('archify/device_info');

  /// Returns a stream that periodically emits storage information.
  ///
  /// This stream updates once per second by calling [_getStorageInfo].
  /// It is typically used to display real-time changes in disk usage
  /// within dashboards or monitoring tools.
  ///
  /// Example:
  /// ```dart
  /// final storageService = StorageService();
  /// storageService.getStreamStorage.listen((data) {
  ///   print('Storage info: $data');
  /// });
  /// ```
  Stream<Map<String, dynamic>> get getStreamStorage {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      return await _getStorageInfo();
    }).asyncMap((future) => future);
  }

  /// Fetches the current storage information from the native layer.
  ///
  /// This method uses the `'getStorageInfo'` call on the native
  /// platform channel `'archify/device_info'`.
  ///
  /// Returns:
  /// - A `Map<String, dynamic>` containing storage metrics such as
  ///   total, used, and available space.
  /// - In case of a platform error, it returns a map with an `'error'` key.
  Future<Map<String, dynamic>> _getStorageInfo() async {
    try {
      final Map<dynamic, dynamic>? result = await _device.invokeMethod(
        'getStorageInfo',
      );
      return (result ?? {}).cast<String, dynamic>();
    } on PlatformException catch (e) {
      return {'error': 'Falha na chamada de Armazenamento: ${e.message}'};
    }
  }
}

import 'dart:io';

import 'package:archify/constants/info_proc_and_soc.dart';

/// A service that provides real-time monitoring and information
/// about the device’s memory (RAM) usage.
///
/// This class reads data directly from the Linux-based
/// `/proc/meminfo` file (through [Hardware.meminfo]) and converts
/// its values from kilobytes (kB) to gigabytes (GB).
///
/// Data is emitted periodically as a [Stream] for continuous monitoring.
class MemoryService {
  /// Instance of the [Hardware] model used to access the memory info path.
  final Hardware _hardware = Hardware();

  /// Provides a stream that periodically emits memory information.
  ///
  /// The stream updates every second, returning a `Map<String, dynamic>`
  /// containing key-value pairs from `/proc/meminfo`, where each entry
  /// represents a different memory metric (e.g., `MemTotal`, `MemFree`).
  ///
  /// Example:
  /// ```dart
  /// final memoryService = MemoryService();
  /// memoryService.getStreamMemory?.listen((data) {
  ///   print('Memory data: $data');
  /// });
  /// ```
  Stream<Map<String, dynamic>>? get getStreamMemory {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      return await _getInforMemory();
    }).asyncMap((future) => future);
  }

  // Reads and processes the memory information file (`/proc/meminfo`).
  //
  // Each line of the file is split into key-value pairs, converted from
  // kilobytes to gigabytes, and stored in a `Map`.
  //
  // Returns:
  // - A `Map<String, dynamic>` containing formatted memory data.
  Future<Map<String, dynamic>> _getInforMemory() async {
    final File file = File(_hardware.meminfo);
    Map<String, dynamic> map = {};

    final List<String> read = await file.readAsLines();
                                                                                              
    for (String item in read) {
      List<String> split = item.split(':');

      map.addAll({split[0]: _convertKBToGB(split[1])});
    }
    return map;
  }

  // Converts a memory value from kilobytes (kB) to gigabytes (GB).
  //
  // The conversion formula is:
  // 1 GB = 1024 × 1024 kB
  //
  // Example:
  // _convertKBToGB("2048000 kB"); // returns "1.95"
  //
  //
  // Returns a string formatted to two decimal places.
  String _convertKBToGB(String kB) {
    final double factor = 1024 * 1024;
    String replace = kB.replaceAll('kB', '');

    String gigabytes = (double.parse(replace) / factor).toStringAsFixed(2);

    return gigabytes;
  }
}

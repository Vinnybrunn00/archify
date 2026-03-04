import 'dart:io';
import 'package:archify/constants/info_proc_and_soc.dart';
import 'package:flutter/services.dart';

/// This service interacts with both the native platform (via [MethodChannel])
/// and the local filesystem to gather details about the device’s CPU performance.
class CPUServices {
  // A helper model that provides hardware-related paths and constants.
  final Hardware _hardware = Hardware();

  /// The communication channel used to invoke native platform methods.
  ///
  /// This channel must be implemented on the native side (e.g., Android)
  /// under the name `'archify/device_info'` and handle CPU-related requests.
  final MethodChannel _device = const MethodChannel('archify/device_info');

  /// A stream that periodically emits the current CPU frequency for each core.
  ///
  /// The stream triggers every second, calling [_getFrequenceCpuInfo]
  /// to retrieve updated frequency values.
  ///
  /// Each emission is a list of doubles, where each value represents
  /// a CPU core’s current frequency in MHz.
  Stream<List<double>> get frequenceCpuStream {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      return await _getFrequenceCpuInfo();
    }).asyncMap((future) => future);
  }

  // Reads the current frequency of each CPU core directly from the filesystem.
  //
  // This method accesses system files located in the CPU frequency directory,
  // typically under `/sys/devices/system/cpu/`.
  //
  // Returns a list of doubles representing the frequency (in MHz) for each core.
  // If a frequency file does not exist or cannot be parsed, it is skipped.
  Future<List<double>> _getFrequenceCpuInfo() async {
    final List<double> listFrequence = [];

    final Map<String, dynamic> getInfo = await getCpuInfo();

    for (int i = 0; i < getInfo['core_count']; i++) {
      final File file = File(
        '${_hardware.cpuSysteminfo}/cpu$i/cpufreq/scaling_cur_freq',
      );

      if (await file.exists()) {
        final String frequence = await file.readAsString();

        final int? frequenceInKzh = int.tryParse(frequence.trim());

        if (frequenceInKzh != null) {
          double frequenceMHz = (frequenceInKzh / 1000);
          listFrequence.add(frequenceMHz);
        }
      }
    }
    return listFrequence;
  }

  /// Retrieves general CPU information from the native platform.
  ///
  /// This method calls the `'getCpuInfo'` function on the native side
  /// via the [_device] [MethodChannel], which should return a map containing
  /// details such as the number of cores, architecture, or model.
  ///
  /// Returns a `Map<String, dynamic>` containing CPU data,
  /// or a map with an error message if no data is returned.
  ///
  Future<Map<String, dynamic>> getCpuInfo() async {
    final Map<dynamic, dynamic>? result = await _device.invokeMethod(
      'getCpuInfo',
    );

    if (result != null) {
      return result.cast<String, dynamic>();
    }
    return {'error': 'No data was returned from the native source.'};
  }
}

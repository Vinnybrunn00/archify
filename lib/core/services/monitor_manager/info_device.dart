import 'dart:async';
import 'package:archify/core/services/monitor_manager/cpu_services.dart';
import 'package:flutter/services.dart';

/// This class extends [CPUServices] to include both hardware-level
/// and platform-level information, such as manufacturer details,
/// model name, and CPU statistics.
class InfoDevice extends CPUServices {
  /// The [MethodChannel] used to communicate with the native platform layer.
  final MethodChannel _device = const MethodChannel('archify/device_info');

  /// Retrieves device information from the native platform and combines it
  /// with CPU data from [getCpuInfo].
  ///
  /// - Calls the native `'getDeviceInfo'` method to fetch device details such as
  ///   manufacturer, model, OS version, and other system-level data.
  /// - Fetches CPU-related data using the inherited [getCpuInfo] method.
  /// - Merges both datasets into a single `Map<String, dynamic>`.
  ///
  /// Returns a map containing combined hardware and system information.
  /// If an error occurs, a map containing an `'error'` key with the failure
  /// message is returned instead.
  ///
  Future<Map<String, dynamic>> getDeviceInfo() async {
    await Future.delayed(Duration(seconds: 1));
    try {
      Map<dynamic, dynamic>? result = await _device.invokeMethod(
        'getDeviceInfo',
      );

      Map<String, dynamic> getInfo = await getCpuInfo();

      if (result != null) {
        result.addAll(getInfo);
        return (result).cast<String, dynamic>();
      }
      return {};
    } on PlatformException catch (e) {
      return {'error': 'Falha na chamada de Info: ${e.message}'};
    }
  }
}

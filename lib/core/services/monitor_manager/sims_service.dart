import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// A service responsible for retrieving SIM card information from
/// the native Android layer through a [MethodChannel].
///
/// This service requires the **Phone** permission in order to access
/// SIM metadata such as carrier name, country code, MCC, MNC, and
/// other SIM-related properties.
///
/// The native side must implement the `'archify/sim_info'` channel
/// and return a map containing all SIM details.
class SimsService {
  // Method channel used to request SIM information from the platform.
  final MethodChannel _simsChannel = MethodChannel('archify/sim_info');

  /// Retrieves SIM card information from the native platform.
  ///
  /// Steps performed:
  /// 1. Requests the `Phone` permission using `permission_handler`.
  /// 2. Calls the native method `'getSimInfo'` via [_simsChannel].
  /// 3. Converts the result into a `Map<String, dynamic>`.
  ///
  /// Throws:
  /// - A [PlatformException] if the platform method fails.
  /// - A type cast error if the native side returns data in an unexpected format.
  ///
  /// Example:
  /// ```dart
  /// final sims = SimsService();
  /// final data = await sims.getSimInfo();
  /// print(data['carrierName']);
  /// ```
  Future<Map<String, dynamic>> getSimInfo() async {
    await Permission.phone.request();
    final info = await _simsChannel.invokeMethod('getSimInfo');
    return Map<String, dynamic>.from(info);
  }
}

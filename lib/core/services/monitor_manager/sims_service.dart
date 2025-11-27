import 'package:flutter/services.dart';

/// A service responsible for retrieving SIM card information from
/// the native Android layer through a [MethodChannel].
class SimsService {
  // Method channel used to request SIM information from the platform.
  final MethodChannel _simsChannel = MethodChannel('archify/sim_info');

  /// Retrieves SIM card information from the native platform.
  Future<Map<String, dynamic>> getSimInfo() async {
    final info = await _simsChannel.invokeMethod('getSimInfo');
    return Map<String, dynamic>.from(info);
  }
}

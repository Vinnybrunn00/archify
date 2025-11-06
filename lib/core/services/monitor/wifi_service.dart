import 'package:flutter/services.dart';

/// A service that provides real-time Wi-Fi network information
/// from the native Android layer using a [MethodChannel].
///
/// This service periodically retrieves Wi-Fi details such as:
/// - SSID (network name)
/// - BSSID (access point identifier)
/// - Signal strength (RSSI)
/// - IP address
/// - Link speed
///
/// The information is exposed as a [Stream] that updates once per second,
/// allowing applications to monitor Wi-Fi status in real time.
class WifiService {
  /// The [MethodChannel] used to communicate with the native Android layer.
  ///
  /// The channel listens to `'archify/wifi_info'`, which should be implemented
  /// in the platform-specific code (Kotlin/Java) to return Wi-Fi information.
  final MethodChannel _wifi = MethodChannel('archify/wifi_info');

  /// A stream that emits Wi-Fi information once per second.
  ///
  /// This is useful for continuously monitoring Wi-Fi connection status
  /// or network metrics in dashboards or background services.
  ///
  /// Example:
  /// ```dart
  /// final wifiService = WifiService();
  /// wifiService.widfiInfoStream.listen((data) {
  ///   print('Wi-Fi info: $data');
  /// });
  /// ```
  Stream<Map<String, dynamic>> get widfiInfoStream {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      return await _getWifiInfo();
    }).asyncMap((future) => future);
  }

  /// Retrieves Wi-Fi information from the native Android layer.
  ///
  /// Calls the platform method `'getWifiInfo'` via [_wifi] and expects
  /// a `Map<String, dynamic>` with network-related data.
  ///
  /// Returns:
  /// - A map containing Wi-Fi information if the native call succeeds.
  /// - An empty map if no data is returned.
  Future<Map<String, dynamic>> _getWifiInfo() async {
    final result = await _wifi.invokeMethod('getWifiInfo');
    return Map<String, dynamic>.from(result ?? {});
  }
}

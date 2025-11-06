import 'package:flutter/services.dart';

/// This class listens to battery-related data sent through a Flutter [EventChannel]
/// and exposes it as a Dart [Stream] that emits events every second.
class BatteryService {
  /// The [EventChannel] used to receive battery information
  /// from the platform-specific implementation.
  final EventChannel _battery = EventChannel('archify/battery_info');

  /// A stream that emits battery information updates from the platform.
  ///
  /// Each event is expected to be a `Map<String, dynamic>` containing
  /// battery-related data (such as level, status, and charging state).
  ///
  /// The stream introduces a 1-second delay between each event emission
  /// to avoid excessive frequency or UI overload.
  Stream<Map<String, dynamic>> get batteryInfoStream async* {
    await for (final event in _battery.receiveBroadcastStream()) {
      await Future.delayed(Duration(seconds: 1));
      yield (event as Map).cast<String, dynamic>();
    }
  }
}

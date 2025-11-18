import 'package:flutter/services.dart';

class SensorsService {
  final MethodChannel _channel = MethodChannel('archify/sensors');

  Future<List<Map<String, dynamic>>> getAllSensors() async {
    final result = await _channel.invokeMethod("getAllSensors");

    if (result == null) return [];

    return List<Map<String, dynamic>>.from(
      (result as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }
}

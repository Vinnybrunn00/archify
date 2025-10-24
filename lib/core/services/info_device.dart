import 'dart:developer';
import 'dart:io';

import 'package:archify/core/models/hardware.dart';
import 'package:archify/utils/utils.dart';
import 'package:flutter/services.dart';

class InfoDevice {
  final EventChannel _battery = EventChannel('archify/battery_info');
  final MethodChannel _device = const MethodChannel('archify/device_info');

  final Utils _utils = Utils();

  final Hardware _hardware = Hardware();

  Stream<Map<String, dynamic>> get getStreamMemory {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      return await getInforMemory();
    }).asyncMap((future) => future);
  }

  Stream<Map<String, dynamic>> get getStreamStorage {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      return await _getStorageInfo();
    }).asyncMap((future) => future);
  }

  Stream<Map<String, dynamic>> get batteryInfoStream {
    return _battery.receiveBroadcastStream().map((dynamic event) {
      return (event as Map).cast<String, dynamic>();
    });
  }

  Future<Map<String, dynamic>> getCpuInfo() async {
    try {
      final Map<dynamic, dynamic>? result = await _device.invokeMethod(
        'getCpuInfo',
      );

      if (result != null) {
        return result.cast<String, dynamic>();
      }
      return {'error': 'Nenhum dado retornado do nativo.'};
    } on PlatformException catch (e) {
      print("Falha ao obter informações da CPU: '${e.message}'.");
      return {'error': 'Falha na chamada nativa: ${e.message}'};
    } catch (e) {
      return {'error': 'Erro desconhecido: $e'};
    }
  }

  // Método já existente (Expandido no Kotlin)
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final Map<dynamic, dynamic>? result = await _device.invokeMethod(
        'getDeviceInfo',
      );
      return (result ?? {}).cast<String, dynamic>();
    } on PlatformException catch (e) {
      return {'error': 'Falha na chamada de Info: ${e.message}'};
    }
  }

  // NOVO MÉTODO: Obter informações de armazenamento
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

  Future<Map<String, dynamic>> getInforMemory() async {
    final File file = File(_hardware.meminfo);
    Map<String, dynamic> map = {};

    final List<String> read = await file.readAsLines();

    for (String item in read) {
      List<String> split = item.split(':');

      map.addAll({split[0]: _utils.convertKBToGB(split[1])});
    }
    return map;
  }
}

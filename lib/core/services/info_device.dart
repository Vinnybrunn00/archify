import 'dart:async';
import 'dart:io';
import 'package:archify/core/models/hardware.dart';
import 'package:archify/utils/utils.dart';
import 'package:flutter/services.dart';

class InfoDevice {
  final EventChannel _battery = EventChannel('archify/battery_info');
  final MethodChannel _device = const MethodChannel('archify/device_info');
  final MethodChannel _wifi = MethodChannel('archify/wifi_info');

  final Utils _utils = Utils();
  final Hardware _hardware = Hardware();

  Stream<Map<String, dynamic>>? get getStreamMemory {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      return await getInforMemory();
    }).asyncMap((future) => future);
  }

  Stream<Map<String, dynamic>> get getStreamStorage {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      return await _getStorageInfo();
    }).asyncMap((future) => future);
  }

  Stream<Map<String, dynamic>> get batteryInfoStream async* {
    await for (final event in _battery.receiveBroadcastStream()) {
      await Future.delayed(Duration(seconds: 1));
      yield (event as Map).cast<String, dynamic>();
    }
  }

  Stream<List<double>> get frequenceCpuStream {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      return await _getFrequenceCpuInfo();
    }).asyncMap((future) => future);
  }

  Stream<Map<String, dynamic>> get widfiInfoStream {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      return await _getWifiInfo();
    }).asyncMap((future) => future);
  }

  // ------------------------------------------------------------------//

  Future<Map<String, dynamic>> _getCpuInfo() async {
    final Map<dynamic, dynamic>? result = await _device.invokeMethod(
      'getCpuInfo',
    );

    if (result != null) {
      return result.cast<String, dynamic>();
    }
    return {'error': 'Nenhum dado retornado do nativo.'};
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    await Future.delayed(Duration(seconds: 1));
    try {
      final Map<dynamic, dynamic>? result = await _device.invokeMethod(
        'getDeviceInfo',
      );
      Map<String, dynamic> getInfo = await _getCpuInfo();

      if (result != null) {
        result.addAll(getInfo);

        return (result).cast<String, dynamic>();
      }
      return {};
    } on PlatformException catch (e) {
      return {'error': 'Falha na chamada de Info: ${e.message}'};
    }
  }

  // Obter informações de armazenamento
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

  Future<List<double>> _getFrequenceCpuInfo() async {
    List<double> listFrequence = [];

    Map<String, dynamic> getInfo = await _getCpuInfo();

    for (int i = 0; i < getInfo['core_count']; i++) {
      final File file = File(
        '${_hardware.cpuinfoMaxFreq}/cpu$i/cpufreq/scaling_cur_freq',
      );

      if (await file.exists()) {
        String frequence = await file.readAsString();

        final int? frequenceInKzh = int.tryParse(frequence.trim());

        if (frequenceInKzh != null) {
          double frequenceMHz = (frequenceInKzh / 1000);
          listFrequence.add(frequenceMHz);
        }
      }
    }
    return listFrequence;
  }

  Future<Map<String, dynamic>> _getWifiInfo() async {
    final result = await _wifi.invokeMethod('getWifiInfo');
    return Map<String, dynamic>.from(result ?? {});
  }

  void test() async {}
}

import 'package:archify/core/models/hardware.dart';

class Device {
  final Map<String, dynamic> _dataDevice;

  Device({required Map<String, dynamic> dataDevice}) : _dataDevice = dataDevice;

  String get manufacturer => _dataDevice['manufacturer'];
  String get model => _dataDevice['model'];
  String get androidVersion => _dataDevice['android_version'];
  String get sdk => _dataDevice['sdk_int'];
  String get socManufacturer => _dataDevice['soc_manufacturer'];
  String get socModel => _dataDevice['soc_model'];
  String get displayId => _dataDevice['display_id'];
  String get hardwareName => _dataDevice['hardware_name'];
  String get boardName => _dataDevice['board_name'];
  String get brand => _dataDevice['brand'];
  String get coreCount => _dataDevice['core_count'];
  String get cpuArchitecture => _dataDevice['cpu_architecture'];
  String get hardwareManufacturer => _dataDevice['hardware_manufacturer'];
  String get readableSoc => _getSocReadableName(socModel);

  String _getSocReadableName(String? socModel) {
    if (socModel == null || socModel.isEmpty) return "Desconhecido";
    return socModels[socModel] ?? socModel;
  }
}

class Sensors {
  final List<Map<String, dynamic>> _listMapSensors;

  Sensors({required List<Map<String, dynamic>> listMapSensors})
    : _listMapSensors = listMapSensors;

  int get sensorsLength => _listMapSensors.length;
}

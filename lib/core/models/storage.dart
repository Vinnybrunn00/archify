import 'dart:math' as math;

class Storage {
  final Map<String, dynamic> _dataStorage;

  Storage({required Map<String, dynamic> dataStorage})
    : _dataStorage = dataStorage;

  double get totalGB => _convertBytesGB(_dataStorage['total_storage_bytes']);
  double get _freeGB =>
      _convertBytesGB(_dataStorage['available_storage_bytes']);
  double get usedGB => totalGB - _freeGB;
  int get percent => ((usedGB / totalGB) * 100).round();

  double _convertBytesGB(int bytes) => bytes / math.pow(1024, 3);
}

import 'dart:math' as math;

class Storage {
  final Map<String, dynamic> _dataStorage;

  Storage({required Map<String, dynamic> dataStorage}) : _dataStorage = dataStorage;

  double get totalGB => _convertBytesForGB(_dataStorage['total_storage_bytes']);
  double get freeGB =>
      _convertBytesForGB(_dataStorage['available_storage_bytes']);
  double get usedGB => totalGB - freeGB;
  int get percent => ((usedGB / totalGB) * 100).round();

  double _convertBytesForGB(int bytes) => bytes / math.pow(1024, 3);
}

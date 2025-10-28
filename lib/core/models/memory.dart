class Memory {
  final Map<String, dynamic> _dataMemory;

  Memory({required Map<String, dynamic> dataMemory}) : _dataMemory = dataMemory;

  String get total => _dataMemory['MemTotal'];
  String get available => _dataMemory['MemAvailable'];
  String get cached => _dataMemory['Cached'];
  String get swapTotal => _dataMemory['SwapTotal'];
  String get swapFree => _dataMemory['SwapFree'];

  double get percent =>
      _convertMemoryPercent(memTotal: total, memAvailable: available);

  double get _percentParse =>
      double.parse('0.${percent.toString().substring(0, 2)}');

  double get setPercent => percent.round() == 100 ? 1 : _percentParse;

  String get used =>
      (double.parse(total) - double.parse(available)).toStringAsFixed(2);

  double _convertMemoryPercent({
    required String memTotal,
    required String memAvailable,
  }) {
    return (1 - double.parse(memAvailable) / double.parse(memTotal)) * 100;
  }
}

class Network {
  final Map<String, dynamic> _dataNetwork;

  Network({required Map<String, dynamic> dataNetwork}) : _dataNetwork = dataNetwork;

  String get ssid => _dataNetwork['ssid'];
  String get bssid => _dataNetwork['bssid'];
  String get frequencyMHz => _dataNetwork['frequencyMHz'];
  String get ipAddress => _dataNetwork['ipAddress'];
  String get dbm => _dataNetwork['rssi'];
  String get speed => _dataNetwork['linkSpeed'];
  bool get is5G => _dataNetwork['is5GHz'];
  bool get isWifiActive => _dataNetwork['isWifiActive'];
}

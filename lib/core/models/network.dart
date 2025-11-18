import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class Network {
  final Map<String, dynamic> _dataNetwork;

  Network({required Map<String, dynamic> dataNetwork})
    : _dataNetwork = dataNetwork;

  String get ssid => _dataNetwork['ssid'];
  String get bssid => _dataNetwork['bssid'];
  String get frequencyMHz => _dataNetwork['frequencyMHz'];
  String get ipAddress => _dataNetwork['ipAddress'];
  String get dbm => _dataNetwork['rssi'];
  String get speed => _dataNetwork['linkSpeed'];
  bool get is5G => _dataNetwork['is5GHz'];
  bool get isWifiActive => _dataNetwork['isWifiActive'];

  String get macAddress => _dataNetwork['macAddress'];
  String get gateway => _dataNetwork['gateway'];
  String get netmask => _dataNetwork['netmask'];
  String get dns1 => _dataNetwork['dns1'];
  String get dns2 => _dataNetwork['dns2'];
  String get router => _dataNetwork['dhcpServer'];
  String get securityType => _dataNetwork['securityType'];
  int get channel => _dataNetwork['channel'];
  int get prefixLength => _dataNetwork['prefixLength'];
  Icon get iconPowerDbm => _setPotencialdBm(dbm);

  List<Map<String, dynamic>> toList() {
    return _dataNetwork.entries
        .map(
          (element) => {
            'key': _changeKeyNames(element.key),
            'value': _setStatusConnect(element.key, element.value),
          },
        )
        .toList();
  }

  _setStatusConnect(String key, dynamic value) {
    if (value is bool) {
      if (key == 'isWifiActive') {
        if (value) return 'Connected';
        return 'Not Connected';
      }
      if (value) return 'Supported';
      return 'Not supported';
    }
    return value;
  }

  Icon _setPotencialdBm(String dbm) {
    final dBmValue = int.tryParse(
      dbm.trim().replaceAll('dBm', '').replaceAll('-', ''),
    );

    if (dBmValue == null) {
      return Icon(BoxIcons.bx_wifi_off, color: Colors.white, size: 35);
    }

    switch (dBmValue) {
      case (<= 30 || <= 41):
        return Icon(BoxIcons.bx_wifi, color: Colors.white, size: 35);
      case (<= 42 || <= 50):
        return Icon(BoxIcons.bx_wifi, color: Colors.white, size: 35);
      case (<= 51 || <= 60):
        return Icon(BoxIcons.bx_wifi_2, color: Colors.white, size: 35);
      case (<= 61 || <= 67):
        return Icon(BoxIcons.bx_wifi_1, color: Colors.white, size: 35);
      case (<= 68 || <= 70):
        return Icon(BoxIcons.bx_wifi_1, color: Colors.white, size: 35);
      case (<= 71 || <= 80):
        return Icon(BoxIcons.bx_wifi_0, color: Colors.white, size: 35);
      case (>= 81):
        return Icon(BoxIcons.bx_wifi_off, color: Colors.white, size: 35);
      default:
        return Icon(BoxIcons.bx_wifi_off, color: Colors.white, size: 35);
    }
  }

  String _changeKeyNames(dynamic values) {
    switch (values) {
      case 'ssid':
        return 'Name';
      case 'bssid':
        return 'Bssid';
      case 'rssi':
        return 'Power';
      case 'linkSpeed':
        return 'Speed Network';
      case 'frequencyMHz':
        return 'Frequency';
      case 'is5GHz':
        return '5G';
      case 'is24GHz':
        return '2.4G';
      case 'ipAddress':
        return 'IP';
      case 'gateway':
        return 'Gateway';
      case 'dhcpServer':
        return 'Router';
      case 'isWifiActive':
        return 'Status';
      case 'securityType':
        return 'Security';
      case 'channel':
        return 'Channel';
      case 'netmask':
        return 'Netmask';
      default:
        return values;
    }
  }
}

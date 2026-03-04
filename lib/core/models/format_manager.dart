import 'dart:math' as math;

import 'package:intl/intl.dart';

class FormatManager {
  String formatBytes(int? bytes, {int decimals = 2, bool useSI = false}) {
    if (bytes == null || bytes == 0) return '0 B';

    if (bytes < 0) {
      return '-${formatBytes(-bytes, decimals: decimals, useSI: useSI)}';
    }

    final int base = useSI ? 1000 : 1024;
    final List<String> suffixes = useSI
        ? ['B', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
        : ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

    final int exponent = math.min(
      (math.log(bytes) / math.log(base)).floor(),
      suffixes.length - 1,
    );

    final double value = bytes / math.pow(base, exponent);
    return '${value.toStringAsFixed(decimals)} ${suffixes[exponent]}';
  }

  String setFormatHour(DateTime dateTime) {
    String formatData = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    return formatData;
  }
}

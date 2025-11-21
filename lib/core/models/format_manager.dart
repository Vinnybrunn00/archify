import 'dart:math' as math;

import 'package:intl/intl.dart';

class FormatManager {
  String formatBytes(int? bytes, {int decimals = 2, bool useSI = false}) {
    if (bytes == null) return '0 B';
    if (bytes < 0) {
      return '-${formatBytes(-bytes, decimals: decimals, useSI: useSI)}';
    }
    if (bytes == 0) return '0 B';

    final base = useSI ? 1000 : 1024;
    final suffixes = useSI
        ? ['B', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
        : ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

    final i = math.min(
      (math.log(bytes) / math.log(base)).floor(),
      suffixes.length - 1,
    );

    final value = bytes / math.pow(base, i);
    return '${value.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  String setFormatHour(DateTime dateTime) {
    String formatData = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    return formatData;
  }
}

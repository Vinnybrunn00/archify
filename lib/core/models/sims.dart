class Sims {
  final Map<Object?, Object?> _mapSims;

  Sims({required Map<Object?, Object?> mapSims}) : _mapSims = mapSims;

  List<Map<String, dynamic>> toList() {
    return _mapSims.entries
        .map(
          (element) => {
            'key': element.key,
            'value': _formatSmartPhone(element.value),
          },
        )
        .toList();
  }

  String _formatSmartPhone(Object? number) {
    String raw = number.toString();

    if (raw.length == 10) {
      // (DD) XXXX-XXXX
      return "(${raw.substring(0, 2)}) "
          "${raw.substring(2, 6)}-${raw.substring(6)}";
    }

    if (raw.length == 11) {
      // (DD) XXXXX-XXXX
      return "(${raw.substring(0, 2)}) "
          "${raw.substring(2, 7)}-${raw.substring(7)}";
    }

    if (raw.length >= 12 && raw.length <= 15) {
      int ccLength = raw.length <= 12 ? 1 : (raw.length == 13 ? 2 : 3);
      String cc = raw.substring(0, ccLength);
      String rest = raw.substring(ccLength);

      List<String> groups = [];

      while (rest.length > 4) {
        groups.add(rest.substring(0, 3));
        rest = rest.substring(3);
      }
      groups.add(rest);

      return "+$cc ${groups.join(' ')}";
    }
    return raw;
  }
}

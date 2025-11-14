class Sims {
  final Map<Object?, Object?> _mapSims;

  Sims({required Map<Object?, Object?> listSims}) : _mapSims = listSims;

  List<Map<String, dynamic>> toList() {
    return _mapSims.entries
        .map((element) => {'key': element.key, 'value': element.value})
        .toList();
  }
}

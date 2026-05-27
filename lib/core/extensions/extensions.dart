/// Optimierer und Erweiterbare Utilities für Strings
extension StringUtils on String {
  /// Bereinigt einen Benutzernamen für die Verarbeitung
  String normalizeUsername() => trim().toLowerCase();

  /// Prüft, ob ein String leer oder nur Whitespace ist
  bool get isBlankOrNull => isEmpty || trim().isEmpty;
}

/// Utility-Methoden für Listen
extension ListUtils<T> on List<T> {
  /// Entfernt Duplikate basierend auf einem Key
  List<T> distinctBy<K>(K Function(T) keyExtractor) {
    final keys = <K>{};
    return where((item) => keys.add(keyExtractor(item))).toList();
  }
}


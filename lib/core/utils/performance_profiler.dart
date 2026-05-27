/// Einfacher Performance-Profiler für kritische Code-Pfade
class PerformanceProfiler {
  static final Map<String, _ProfilerEntry> _entries = {};

  /// Misst die Ausführungsdauer einer async Funktion
  static Future<T> measure<T>(
    String label,
    Future<T> Function() computation,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await computation();
      stopwatch.stop();
      _recordDuration(label, stopwatch.elapsedMilliseconds);
      return result;
    } catch (e) {
      stopwatch.stop();
      _recordDuration(label, stopwatch.elapsedMilliseconds, isError: true);
      rethrow;
    }
  }

  static void _recordDuration(String label, int ms, {bool isError = false}) {
    final key = isError ? '$label (ERROR)' : label;
    if (!_entries.containsKey(key)) {
      _entries[key] = _ProfilerEntry();
    }
    _entries[key]!.record(ms);
  }

  /// Gibt Profiling-Zusammenfassung aus
  static String getSummary() {
    final buffer = StringBuffer('Performance Summary:\n');
    _entries.forEach((label, entry) {
      buffer.writeln('  $label: ${entry.average.toStringAsFixed(2)}ms (${entry.count}x)');
    });
    return buffer.toString();
  }

  static void reset() => _entries.clear();
}

class _ProfilerEntry {
  int count = 0;
  int totalMs = 0;

  void record(int ms) {
    count++;
    totalMs += ms;
  }

  double get average => totalMs / count;
}


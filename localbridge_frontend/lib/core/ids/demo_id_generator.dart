/// Generates readable, session-stable identifiers for demo records.
class DemoIdGenerator {
  int _sequence = 0;

  /// Returns the next identifier for [prefix], for example `quote-1`.
  String next(String prefix) => '$prefix-${++_sequence}';
}

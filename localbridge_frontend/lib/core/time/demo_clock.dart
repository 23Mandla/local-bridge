/// Fixed clock used by the LocalBridge demo.
///
/// The demo data is seeded around a fixed "today" so that relative labels,
/// closing dates and quote timestamps stay deterministic between runs.
class DemoClock {
  const DemoClock._();

  /// The date the demo pretends it is.
  static final DateTime today = DateTime(2026, 3, 16);

  /// The timestamp used for demo writes (draft saves, submissions, decisions).
  static DateTime now() => DateTime(2026, 3, 16, 9, 30);
}
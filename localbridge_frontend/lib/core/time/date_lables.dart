const List<String> _monthNames = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Formats a date as `16 Mar 2026`.
String formatDemoDate(DateTime date) =>
    '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

/// Number of whole days between two dates, ignoring the time of day.
int daysBetween(DateTime from, DateTime to) {
  final start = DateTime(from.year, from.month, from.day);
  final end = DateTime(to.year, to.month, to.day);
  return end.difference(start).inDays;
}

/// Human readable closing label, for example `Closes in 3 days` or
/// `Closed 4 days ago`.
String relativeClosingLabel(DateTime closingDate, {DateTime? now}) {
  final difference = daysBetween(now ?? DateTime.now(), closingDate);
  if (difference > 1) return 'Closes in $difference days';
  if (difference == 1) return 'Closes tomorrow';
  if (difference == 0) return 'Closes today';
  if (difference == -1) return 'Closed yesterday';
  return 'Closed ${-difference} days ago';
}

/// Whether [closingDate] is in the past relative to [now].
bool hasClosed(DateTime closingDate, {DateTime? now}) =>
    daysBetween(now ?? DateTime.now(), closingDate) < 0;

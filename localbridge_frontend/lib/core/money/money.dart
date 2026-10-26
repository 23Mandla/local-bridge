/// Money helpers for the LocalBridge demo.
///
/// Every amount in the domain layer is an `int` number of South African cents.
/// Conversion to and from display strings only happens at the UI boundary, so
/// no widget owns a monetary calculation.
class Money {
  const Money._();

  static const String _symbol = 'R';

  /// Rounds a decimal Rand [value] to the nearest cent.
  static int roundToCents(double value) => (value * 100).round();

  /// Formats [cents] as South African Rand, for example `R 4 500,00`.
  static String format(int cents) => '$_symbol ${formatPlain(cents)}';

  /// Formats [cents] without the currency symbol, for example `4 500,00`.
  static String formatPlain(int cents) {
    final absolute = cents.abs();
    final rands = _groupThousands((absolute ~/ 100).toString());
    final fraction = (absolute % 100).toString().padLeft(2, '0');
    return '${cents < 0 ? '-' : ''}$rands,$fraction';
  }

  /// Converts [cents] into a value the user can edit, for example `4500` or
  /// `4500,50`. A zero amount becomes an empty string.
  static String toEditableInput(int cents) {
    if (cents == 0) return '';
    final absolute = cents.abs();
    final rands = (absolute ~/ 100).toString();
    final fraction = absolute % 100;
    final sign = cents < 0 ? '-' : '';
    if (fraction == 0) return '$sign$rands';
    return '$sign$rands,${fraction.toString().padLeft(2, '0')}';
  }

  /// Parses user input such as `4 500,00`, `R4500` or `4500.5` into cents.
  ///
  /// Returns `null` when the input does not contain a valid, non-negative
  /// amount with at most two decimal places.
  static int? parseToCents(String input) {
    final cleaned = input.replaceAll(RegExp(r'[Rr\s\u00A0]'), '');
    if (cleaned.isEmpty) return null;
    if (cleaned.contains('-') || cleaned.contains('+')) return null;

    final separators = <int>[
      for (var i = 0; i < cleaned.length; i++)
        if (cleaned[i] == ',' || cleaned[i] == '.') i,
    ];

    var wholePart = cleaned;
    var fractionPart = '';

    if (separators.isNotEmpty) {
      final decimalIndex = separators.last;
      final candidate = cleaned.substring(decimalIndex + 1);
      final candidateIsNumeric =
          candidate.isNotEmpty &&
              candidate.length <= 2 &&
              candidate.replaceAll(RegExp(r'[^0-9]'), '') == candidate;
      if (candidateIsNumeric) {
        wholePart = cleaned.substring(0, decimalIndex);
        fractionPart = candidate;
      } else if (separators.length == 1 && candidate.isEmpty) {
        wholePart = cleaned.substring(0, decimalIndex);
      }
    }

    final wholeDigits = wholePart.replaceAll(RegExp(r'[^0-9]'), '');
    final fractionDigits = fractionPart.replaceAll(RegExp(r'[^0-9]'), '');
    if (wholeDigits.isEmpty && fractionDigits.isEmpty) return null;

    final whole = wholeDigits.isEmpty ? 0 : int.tryParse(wholeDigits);
    if (whole == null) return null;

    final fraction = fractionDigits.isEmpty
        ? 0
        : int.parse(fractionDigits.padRight(2, '0'));

    return whole * 100 + fraction;
  }

  /// Returns [part] as a fraction of [whole], or `0` when [whole] is not a
  /// positive amount (guards against division by zero).
  static double share(int part, int whole) {
    if (whole <= 0) return 0;
    return part / whole;
  }

  /// Returns [fraction] of [cents], rounded to the nearest cent.
  static int percentOf(int cents, double fraction) =>
      roundToCents(cents * fraction);

  /// Formats [fraction] as a whole percentage, for example `69%`.
  static String formatPercentage(double fraction) =>
      '${(fraction * 100).round()}%';

  static String _groupThousands(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

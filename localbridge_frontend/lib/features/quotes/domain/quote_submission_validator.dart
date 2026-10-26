import 'entities/quote.dart';

/// Submission rules for a quotation.
///
/// The same rules drive the inline feedback in the quote editor and the check
/// the repository performs when a quote is submitted, so an invalid quote can
/// never reach the buyer.
class QuoteSubmissionValidator {
  const QuoteSubmissionValidator._();

  /// Issues with a single line, for example a missing description.
  static List<String> lineIssues(QuoteLine line) {
    final issues = <String>[];
    if (line.description.trim().isEmpty) {
      issues.add('Add a description for this line');
    }
    if (line.quantity < 1) {
      issues.add('Quantity must be at least 1');
    }
    if (line.unitPriceCents <= 0) {
      issues.add('Enter a unit price greater than R 0,00');
    }
    return issues;
  }

  static bool isValidLine(QuoteLine line) => lineIssues(line).isEmpty;

  /// Issues that block submission of the whole quote.
  static List<String> validate(Quote quote, {required DateTime now}) {
    final issues = <String>[];

    if (quote.lines.where(isValidLine).isEmpty) {
      issues.add('Add at least one complete quote line before submitting.');
    }

    for (var index = 0; index < quote.lines.length; index++) {
      final lineIssuesForLine = lineIssues(quote.lines[index]);
      for (final issue in lineIssuesForLine) {
        issues.add('Line ${index + 1}: $issue.');
      }
    }

    for (final requirement in quote.requirements) {
      if (requirement.isMandatory &&
          quote.responseFor(requirement.id) == null) {
        issues.add('Respond to: "${requirement.text}".');
      }
    }

    if (quote.upfrontCents > quote.totalCents) {
      issues.add('Upfront cash cannot be more than the quote total.');
    }

    if (!quote.isOpportunityOpenAt(now)) {
      issues.add('This opportunity is closed and cannot receive new quotes.');
    }

    return issues;
  }
}

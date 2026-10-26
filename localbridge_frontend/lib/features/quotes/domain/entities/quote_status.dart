/// Lifecycle of a quotation.
///
/// `draft -> submitted -> accepted | declined`; decided quotes are final.
enum QuoteStatus {
  draft('Draft'),
  submitted('Submitted'),
  accepted('Accepted'),
  declined('Declined');

  const QuoteStatus(this.label);

  final String label;

  bool get isDraft => this == QuoteStatus.draft;

  bool get isSubmitted => this == QuoteStatus.submitted;

  bool get isDecided =>
      this == QuoteStatus.accepted || this == QuoteStatus.declined;

  /// Only drafts may be edited, and only submitted quotes may be decided.
  bool get canBeEdited => isDraft;

  bool get canBeDecided => isSubmitted;
}

/// The buyer's verdict on a submitted quote.
enum QuoteDecision {
  accept('Accept quote', QuoteStatus.accepted),
  decline('Decline quote', QuoteStatus.declined);

  const QuoteDecision(this.label, this.resultingStatus);

  final String label;
  final QuoteStatus resultingStatus;
}
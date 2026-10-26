import 'package:localbridge_frontend/features/quotes/domain/entities/quote_status.dart';

import '../../../../core/money/money.dart';
import '../../../../core/time/date_lables.dart';

/// One priced line on a quotation.
class QuoteLine {
  final String id;
  final String description;
  final int quantity;
  final int unitPriceCents;

  const QuoteLine({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPriceCents,
  });

  /// Line total, always derived from quantity and unit price.
  int get lineTotalCents => quantity * unitPriceCents;

  QuoteLine copyWith({
    String? description,
    int? quantity,
    int? unitPriceCents,
  }) => QuoteLine(
    id: id,
    description: description ?? this.description,
    quantity: quantity ?? this.quantity,
    unitPriceCents: unitPriceCents ?? this.unitPriceCents,
  );
}

/// Snapshot of a buyer requirement the quote must respond to.
class QuoteRequirement {
  final String id;
  final String text;
  final bool isMandatory;

  const QuoteRequirement({
    required this.id,
    required this.text,
    required this.isMandatory,
  });
}

/// The entrepreneur's answer to a single buyer requirement.
///
/// A response only exists once the entrepreneur has answered the requirement,
/// which is what makes a requirement count as answered.
class RequirementResponse {
  final String requirementId;
  final bool canMeet;
  final String note;

  const RequirementResponse({
    required this.requirementId,
    this.canMeet = false,
    this.note = '',
  });

  RequirementResponse copyWith({bool? canMeet, String? note}) =>
      RequirementResponse(
        requirementId: requirementId,
        canMeet: canMeet ?? this.canMeet,
        note: note ?? this.note,
      );
}

/// A quotation prepared by the business for an opportunity.
class Quote {
  /// Upfront cash above this share of the total is flagged in the UI.
  static const double upfrontWarningThreshold = 0.60;

  final String id;
  final String opportunityId;
  final String opportunityTitle;
  final DateTime opportunityClosingDate;
  final String businessId;
  final String businessName;
  final QuoteStatus status;
  final List<QuoteLine> lines;
  final int upfrontCents;
  final String buyerMessage;
  final List<QuoteRequirement> requirements;
  final List<RequirementResponse> responses;
  final DateTime preparedAt;
  final DateTime? submittedAt;
  final DateTime? decidedAt;
  final String? buyerNote;

  const Quote({
    required this.id,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.opportunityClosingDate,
    required this.businessId,
    required this.businessName,
    this.status = QuoteStatus.draft,
    this.lines = const [],
    this.upfrontCents = 0,
    this.buyerMessage = '',
    this.requirements = const [],
    this.responses = const [],
    required this.preparedAt,
    this.submittedAt,
    this.decidedAt,
    this.buyerNote,
  });

  /// Quote total, always derived from the priced lines.
  int get totalCents => lines.fold(0, (sum, line) => sum + line.lineTotalCents);

  /// Upfront cash as a fraction of the total (0 when the total is unknown).
  double get upfrontShare => Money.share(upfrontCents, totalCents);

  bool get upfrontExceedsThreshold => upfrontShare > upfrontWarningThreshold;

  bool get canBeEdited => status.canBeEdited;

  bool get canBeDecided => status.canBeDecided;

  bool isOpportunityOpenAt(DateTime now) =>
      !hasClosed(opportunityClosingDate, now: now);

  RequirementResponse? responseFor(String requirementId) {
    for (final response in responses) {
      if (response.requirementId == requirementId) return response;
    }
    return null;
  }

  int get answeredRequirementCount =>
      requirements.where((item) => responseFor(item.id) != null).length;

  Quote copyWith({
    String? opportunityTitle,
    QuoteStatus? status,
    List<QuoteLine>? lines,
    int? upfrontCents,
    String? buyerMessage,
    List<QuoteRequirement>? requirements,
    List<RequirementResponse>? responses,
    DateTime? submittedAt,
    DateTime? decidedAt,
    String? buyerNote,
  }) => Quote(
    id: id,
    opportunityId: opportunityId,
    opportunityTitle: opportunityTitle ?? this.opportunityTitle,
    opportunityClosingDate: opportunityClosingDate,
    businessId: businessId,
    businessName: businessName,
    status: status ?? this.status,
    lines: lines ?? this.lines,
    upfrontCents: upfrontCents ?? this.upfrontCents,
    buyerMessage: buyerMessage ?? this.buyerMessage,
    requirements: requirements ?? this.requirements,
    responses: responses ?? this.responses,
    preparedAt: preparedAt,
    submittedAt: submittedAt ?? this.submittedAt,
    decidedAt: decidedAt ?? this.decidedAt,
    buyerNote: buyerNote ?? this.buyerNote,
  );
}
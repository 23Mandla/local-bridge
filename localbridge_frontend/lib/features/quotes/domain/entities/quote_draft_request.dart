import 'package:localbridge_frontend/features/opportunities/domain/entities/opportunity.dart';

import 'quote.dart';

/// Everything the quotes feature needs to open a draft for an opportunity.
///
/// The opportunity is passed in as plain values so the quotes repository never
/// depends on the opportunities data layer.
class QuoteDraftRequest {
  final String opportunityId;
  final String opportunityTitle;
  final DateTime opportunityClosingDate;
  final List<QuoteRequirement> requirements;

  const QuoteDraftRequest({
    required this.opportunityId,
    required this.opportunityTitle,
    required this.opportunityClosingDate,
    required this.requirements,
  });

  /// Snapshots the opportunity details a quote must keep for its lifetime.
  factory QuoteDraftRequest.fromOpportunity(Opportunity opportunity) =>
      QuoteDraftRequest(
        opportunityId: opportunity.id,
        opportunityTitle: opportunity.title,
        opportunityClosingDate: opportunity.closingDate,
        requirements: opportunity.requirements
            .map(
              (requirement) => QuoteRequirement(
            id: requirement.id,
            text: requirement.text,
            isMandatory: requirement.isMandatory,
          ),
        )
            .toList(),
      );
}
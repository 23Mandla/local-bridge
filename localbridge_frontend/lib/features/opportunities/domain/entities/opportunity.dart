import '../../../../core/time/date_lables.dart';
import 'opportunity_requirements.dart';
import 'opportunity_status.dart';

class Opportunity {
  final String id;
  final String title;
  final String description;
  final String location;
  final String category;
  final DateTime closingDate;
  final DateTime deliveryDate;
  final int budgetCents;
  final OpportunityStatus status;
  final String buyerName;
  final String buyerOrganisation;
  final List<OpportunityRequirements> requirements;

  const Opportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.closingDate,
    required this.deliveryDate,
    required this.budgetCents,
    required this.status,
    required this.buyerName,
    required this.buyerOrganisation,
    required this.requirements,
  });

  int get requirementCount => requirements.length;

  int get mandatoryRequirementCount =>
      requirements.where((requirement) => requirement.isMandatory).length;

  /// Whether the opportunity can still receive a new quote at [now].
  bool isOpenAt(DateTime now) =>
      status == OpportunityStatus.open && !hasClosed(closingDate, now: now);
}
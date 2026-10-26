import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/opportunity.dart';
import '../../domain/entities/opportunity_status.dart';
import 'buyer_dto.dart';
import 'opportunity_requirements_dto.dart';

part 'opportunities_dto.g.dart';


@JsonSerializable(explicitToJson: true)
class OpportunitiesDto {
  final String id;
  final String title;
  final String description;
  final String location;
  final String category;
  final DateTime closingDate;
  final DateTime deliveryDate;
  final int budgetCents;
  final String status;
  final BuyerDto buyer;
  final List<OpportunityRequirementsDto> requirements;

  const OpportunitiesDto({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.closingDate,
    required this.deliveryDate,
    required this.budgetCents,
    required this.status,
    required this.buyer,
    required this.requirements,
  });

  factory OpportunitiesDto.fromJson(Map<String, dynamic> json) =>
      _$OpportunitiesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OpportunitiesDtoToJson(this);

  factory OpportunitiesDto.fromDomain(Opportunity opportunity) =>
      OpportunitiesDto(
        id: opportunity.id,
        title: opportunity.title,
        description: opportunity.description,
        location: opportunity.location,
        category: opportunity.category,
        closingDate: opportunity.closingDate,
        deliveryDate: opportunity.deliveryDate,
        budgetCents: opportunity.budgetCents,
        status: opportunity.status.label,
        buyer: BuyerDto.fromDomain(
          name: opportunity.buyerName,
          organisation: opportunity.buyerOrganisation,
        ),
        requirements: opportunity.requirements
            .map(OpportunityRequirementsDto.fromDomain)
            .toList(),
      );

  Opportunity toDomain() => Opportunity(
    id: id,
    title: title,
    description: description,
    location: location,
    category: category,
    closingDate: closingDate,
    deliveryDate: deliveryDate,
    budgetCents: budgetCents,
    status: OpportunityStatus.fromLabel(status),
    buyerName: buyer.name,
    buyerOrganisation: buyer.organisation,
    requirements: requirements
        .map((requirement) => requirement.toDomain())
        .toList(),
  );
}
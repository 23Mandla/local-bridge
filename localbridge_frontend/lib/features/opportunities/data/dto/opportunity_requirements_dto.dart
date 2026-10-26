import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/opportunity_requirements.dart';

part 'opportunity_requirements_dto.g.dart';

@JsonSerializable()
class OpportunityRequirementsDto {
  final String id;
  final String text;
  final bool isMandatory;

  const OpportunityRequirementsDto({
    required this.id,
    required this.text,
    required this.isMandatory,
  });

  factory OpportunityRequirementsDto.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$OpportunityRequirementsDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OpportunityRequirementsDtoToJson(this);

  factory OpportunityRequirementsDto.fromDomain(
      OpportunityRequirements requirement,
      ) {
    return OpportunityRequirementsDto(
      id: requirement.id,
      text: requirement.text,
      isMandatory: requirement.isMandatory,
    );
  }

  OpportunityRequirements toDomain() {
    return OpportunityRequirements(
      id: id,
      text: text,
      isMandatory: isMandatory,
    );
  }
}
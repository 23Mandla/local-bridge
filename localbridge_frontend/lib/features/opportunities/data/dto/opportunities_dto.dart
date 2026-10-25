import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/opportunity.dart';

part 'opportunities_dto.g.dart';

@JsonSerializable()
class OpportunitiesDto {
  final String title;
  final String description;
  final String location;
  final String category;
  final String deadline;
  final String budget;
  final int requirements;
  final String status;

  const OpportunitiesDto({
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.deadline,
    required this.budget,
    required this.requirements,
    required this.status,
  });

  factory OpportunitiesDto.fromJson(Map<String, dynamic> json) =>
      _$OpportunitiesDtoFromJson(json);

  Opportunity toDomain(){
    return Opportunity(
        title: title,
        description: description,
        location: location,
        category: category,
        deadline: deadline,
        budget: budget,
        requirements: requirements,
        status: status
    );
  }
}
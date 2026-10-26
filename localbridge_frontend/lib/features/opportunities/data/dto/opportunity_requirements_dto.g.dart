// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity_requirements_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpportunityRequirementsDto _$OpportunityRequirementsDtoFromJson(
  Map<String, dynamic> json,
) => OpportunityRequirementsDto(
  id: json['id'] as String,
  text: json['text'] as String,
  isMandatory: json['isMandatory'] as bool,
);

Map<String, dynamic> _$OpportunityRequirementsDtoToJson(
  OpportunityRequirementsDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'isMandatory': instance.isMandatory,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunities_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpportunitiesDto _$OpportunitiesDtoFromJson(Map<String, dynamic> json) =>
    OpportunitiesDto(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      category: json['category'] as String,
      deadline: json['deadline'] as String,
      budget: json['budget'] as String,
      requirements: (json['requirements'] as num).toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$OpportunitiesDtoToJson(OpportunitiesDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'category': instance.category,
      'deadline': instance.deadline,
      'budget': instance.budget,
      'requirements': instance.requirements,
      'status': instance.status,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunities_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpportunitiesDto _$OpportunitiesDtoFromJson(Map<String, dynamic> json) =>
    OpportunitiesDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      category: json['category'] as String,
      closingDate: DateTime.parse(json['closingDate'] as String),
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      budgetCents: (json['budgetCents'] as num).toInt(),
      status: json['status'] as String,
      buyer: BuyerDto.fromJson(json['buyer'] as Map<String, dynamic>),
      requirements: (json['requirements'] as List<dynamic>)
          .map(
            (e) =>
                OpportunityRequirementsDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$OpportunitiesDtoToJson(OpportunitiesDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'category': instance.category,
      'closingDate': instance.closingDate.toIso8601String(),
      'deliveryDate': instance.deliveryDate.toIso8601String(),
      'budgetCents': instance.budgetCents,
      'status': instance.status,
      'buyer': instance.buyer.toJson(),
      'requirements': instance.requirements.map((e) => e.toJson()).toList(),
    };

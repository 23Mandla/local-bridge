import 'package:json_annotation/json_annotation.dart';

part 'buyer_dto.g.dart';

@JsonSerializable()
class BuyerDto {
  final String name;
  final String organisation;

  const BuyerDto({
    required this.name,
    required this.organisation,
  });

  factory BuyerDto.fromJson(Map<String, dynamic> json) =>
      _$BuyerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BuyerDtoToJson(this);

  factory BuyerDto.fromDomain({
    required String name,
    required String organisation,
  }) {
    return BuyerDto(
      name: name,
      organisation: organisation,
    );
  }
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerResponseModel _$CustomerResponseModelFromJson(
  Map<String, dynamic> json,
) => CustomerResponseModel(
  id: json['id'] as String,
  proprietario: json['proprietario'] as String?,
  responsavelTechnico: json['responsavelTechnico'] as String?,
  projeto: json['projeto'] as String?,
  email: json['email'] as String?,
  primaryPhone: json['primaryPhone'] as String?,
  secondaryPhone: json['secondaryPhone'] as String?,
  customerSituation: (json['customerSituation'] as num?)?.toInt(),
  entity: json['entity'] as String?,
  address: json['address'] as String?,
  orgOwner: json['orgOwner'] as String?,
  walletId: json['walletId'] as String?,
);

Map<String, dynamic> _$CustomerResponseModelToJson(
  CustomerResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'proprietario': instance.proprietario,
  'responsavelTechnico': instance.responsavelTechnico,
  'projeto': instance.projeto,
  'email': instance.email,
  'primaryPhone': instance.primaryPhone,
  'secondaryPhone': instance.secondaryPhone,
  'customerSituation': instance.customerSituation,
  'entity': instance.entity,
  'address': instance.address,
  'orgOwner': instance.orgOwner,
  'walletId': instance.walletId,
};

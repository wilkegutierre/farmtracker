// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_lot_culture_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectLotCultureModel _$ProjectLotCultureModelFromJson(
  Map<String, dynamic> json,
) => ProjectLotCultureModel(
  uuid: json['uuid'] as String,
  costumer: json['costumer'] as String,
  path: json['path'] as String,
  project: json['project'] as String,
  lot: json['lot'] as String,
  culture: json['culture'] as String,
  hectareCulture: (json['hectareCulture'] as num).toDouble(),
);

Map<String, dynamic> _$ProjectLotCultureModelToJson(
  ProjectLotCultureModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'costumer': instance.costumer,
  'path': instance.path,
  'project': instance.project,
  'lot': instance.lot,
  'culture': instance.culture,
  'hectareCulture': instance.hectareCulture,
};

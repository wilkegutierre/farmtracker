import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_project_lot_culture_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseProjectLotCultureModel with EquatableMixin {
  final String uuid;
  final String costumer;
  final String path;
  final String project;
  final String lot;
  final String culture;
  final double hectareCulture;

  ResponseProjectLotCultureModel({
    required this.uuid,
    required this.costumer,
    required this.path,
    required this.project,
    required this.lot,
    required this.culture,
    required this.hectareCulture,
  });

  ResponseProjectLotCultureModel copyWith({
    String? uuid,
    String? costumer,
    String? path,
    String? project,
    String? lot,
    String? culture,
    double? hectareCulture,
  }) {
    return ResponseProjectLotCultureModel(
      uuid: uuid ?? this.uuid,
      costumer: costumer ?? this.costumer,
      path: path ?? this.path,
      project: project ?? this.project,
      lot: lot ?? this.lot,
      culture: culture ?? this.culture,
      hectareCulture: hectareCulture ?? this.hectareCulture,
    );
  }

  @override
  List<Object?> get props => [uuid, costumer, path, project, lot, culture, hectareCulture];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$ResponseProjectLotCultureModelToJson(this);

  factory ResponseProjectLotCultureModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseProjectLotCultureModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());
}

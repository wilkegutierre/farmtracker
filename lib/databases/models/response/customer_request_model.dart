import 'dart:convert';

import 'package:equatable/equatable.dart';

class CustomerResponseModel with EquatableMixin {
  final String id;
  final String? proprietario;
  final String? responsavelTechnico;
  final String? projeto;
  final String? email;
  final String? primaryPhone;
  final String? secondaryPhone;
  final int? customerSituation;
  final String? entity;
  final String? address;
  final String? orgOwner;
  final String? walletId;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  CustomerResponseModel({
    required this.id,
    this.proprietario,
    this.responsavelTechnico,
    this.projeto,
    this.email,
    this.primaryPhone,
    this.secondaryPhone,
    this.customerSituation,
    this.entity,
    this.address,
    this.orgOwner,
    this.walletId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  CustomerResponseModel copyWith({
    String? id,
    String? proprietario,
    String? responsavelTechnico,
    String? projeto,
    String? email,
    String? primaryPhone,
    String? secondaryPhone,
    int? customerSituation,
    String? entity,
    String? address,
    String? orgOwner,
    String? walletId,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return CustomerResponseModel(
      id: id ?? this.id,
      proprietario: proprietario ?? this.proprietario,
      responsavelTechnico: responsavelTechnico ?? this.responsavelTechnico,
      projeto: projeto ?? this.projeto,
      email: email ?? this.email,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      customerSituation: customerSituation ?? this.customerSituation,
      entity: entity ?? this.entity,
      address: address ?? this.address,
      orgOwner: orgOwner ?? this.orgOwner,
      walletId: walletId ?? this.walletId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    proprietario,
    responsavelTechnico,
    projeto,
    email,
    primaryPhone,
    secondaryPhone,
    customerSituation,
    entity,
    address,
    orgOwner,
    walletId,
    createdBy,
    createdAt,
    updatedAt,
  ];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    'id': id,
    'proprietario': proprietario,
    'responsavel_technico': responsavelTechnico,
    'projeto': projeto,
    'email': email,
    'primary_phone': primaryPhone,
    'secondary_phone': secondaryPhone,
    'customer_situation': customerSituation,
    'entity': entity,
    'address': address,
    'org_owner': orgOwner,
    'wallet_id': walletId,
    'created_by': createdBy,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerResponseModel(
      id: json['id'] as String,
      proprietario: json['proprietario'] as String?,
      responsavelTechnico: json['responsavel_technico'] as String?,
      projeto: json['projeto'] as String?,
      email: json['email'] as String?,
      primaryPhone: json['primary_phone'] as String?,
      secondaryPhone: json['secondary_phone'] as String?,
      customerSituation: json['customer_situation'] as int?,
      entity: json['entity'] as String?,
      address: json['address'] as String?,
      orgOwner: json['org_owner'] as String?,
      walletId: json['wallet_id'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

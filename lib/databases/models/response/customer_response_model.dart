import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomerResponseModel with EquatableMixin {
  final String id;
  final String? proprietario;
  final String? responsavelTecnico;
  final String? projeto;
  final String? email;
  final String? primaryPhone;
  final String? secondaryPhone;
  final int? customerSituation;
  final String? entity;
  final String? address;
  final String? orgOwner;
  final String? walletId;

  CustomerResponseModel({
    required this.id,
    this.proprietario,
    this.responsavelTecnico,
    this.projeto,
    this.email,
    this.primaryPhone,
    this.secondaryPhone,
    this.customerSituation,
    this.entity,
    this.address,
    this.orgOwner,
    this.walletId,
  });

  CustomerResponseModel copyWith({
    String? id,
    String? proprietario,
    String? responsavelTecnico,
    String? projeto,
    String? email,
    String? primaryPhone,
    String? secondaryPhone,
    int? customerSituation,
    String? entity,
    String? address,
    String? orgOwner,
    String? walletId,
  }) {
    return CustomerResponseModel(
      id: id ?? this.id,
      proprietario: proprietario ?? this.proprietario,
      responsavelTecnico: responsavelTecnico ?? this.responsavelTecnico,
      projeto: projeto ?? this.projeto,
      email: email ?? this.email,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      customerSituation: customerSituation ?? this.customerSituation,
      entity: entity ?? this.entity,
      address: address ?? this.address,
      orgOwner: orgOwner ?? this.orgOwner,
      walletId: walletId ?? this.walletId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    proprietario,
    responsavelTecnico,
    projeto,
    email,
    primaryPhone,
    secondaryPhone,
    customerSituation,
    entity,
    address,
    orgOwner,
    walletId,
  ];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$CustomerResponseModelToJson(this);

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) => _$CustomerResponseModelFromJson(json);
}

// extension CustomerResponseModelMapper on CustomerResponseModel {
//   CustomerModel toModel() {
//     return CustomerModel(id: id, proprietario: proprietario, responsavelTechnico: responsavelTechnico, projeto: projeto, email: email, primaryPhone: primaryPhone, secondaryPhone: secondaryPhone, customerSituation: customerSituation, entity: entity, address: address, orgOwner: orgOwner, walletId: walletId);
//   }
// }

// extension CustomersResponseModelMapper on List<CustomerResponseModel> {
//   List<CustomerModel> toMapModel() {
//     return map((customer) => customer.toModel()).toList();
//   }
// }

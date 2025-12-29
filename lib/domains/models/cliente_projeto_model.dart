// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ClienteProjetoModel with EquatableMixin {
  final String cliente;
  final String projeto;

  ClienteProjetoModel({required this.cliente, required this.projeto});

  @override
  List<Object> get props => [cliente, projeto];

  ClienteProjetoModel copyWith({
    String? cliente,
    String? projeto,
  }) {
    return ClienteProjetoModel(
      cliente: cliente ?? this.cliente,
      projeto: projeto ?? this.projeto,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClienteCulturaRelacaoModel {
  final String idCliente;
  final String idCultura;
  final String nomeCultura;
  final String descricaoCultura;
  final double areaCultura;

  ClienteCulturaRelacaoModel({
    required this.idCliente,
    required this.idCultura,
    required this.nomeCultura,
    required this.descricaoCultura,
    required this.areaCultura,
  });

  ClienteCulturaRelacaoModel copyWith({
    String? idCliente,
    String? idCultura,
    String? nomeCultura,
    String? descricaoCultura,
    double? areaCultura,
  }) {
    return ClienteCulturaRelacaoModel(
      idCliente: idCliente ?? this.idCliente,
      idCultura: idCultura ?? this.idCultura,
      nomeCultura: nomeCultura ?? this.nomeCultura,
      descricaoCultura: descricaoCultura ?? this.descricaoCultura,
      areaCultura: areaCultura ?? this.areaCultura,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/cliente_cultura_model.dart';
import 'package:farmtracker/domains/models/cliente_cultura_relacao_model.dart';
import 'package:farmtracker/domains/models/cliente_model.dart';

enum ProjectoStateFlow { projeto, lote, cultura }

sealed class ClienteState extends Equatable {
  const ClienteState();

  @override
  List<Object?> get props => [];
}

final class ClienteInitial extends ClienteState {
  const ClienteInitial();
}

final class ClienteLoading extends ClienteState {
  const ClienteLoading();
}

final class ClienteSincronizado extends ClienteState {
  const ClienteSincronizado();
}

final class ClienteRelacaoCarregada extends ClienteState {
  final List<ClienteModel> clientes;

  const ClienteRelacaoCarregada(this.clientes);

  @override
  List<Object?> get props => [clientes];
}

final class ClienteCarregado extends ClienteState {
  final ClienteModel cliente;

  const ClienteCarregado(this.cliente);

  @override
  List<Object?> get props => [cliente];
}

final class ClienteGravadoSucesso extends ClienteState {
  final ClienteModel cliente;

  const ClienteGravadoSucesso(this.cliente);

  @override
  List<Object?> get props => [cliente];
}

final class ClienteFluxoAtualizado extends ClienteState {
  final ProjectoStateFlow fluxo;
  final String? projeto;
  final String? lote;

  const ClienteFluxoAtualizado({required this.fluxo, this.projeto, this.lote});

  @override
  List<Object?> get props => [fluxo, projeto, lote];
}

final class ClienteCulturasCarregadas extends ClienteState {
  final List<ClienteCulturaModel> culturas;

  const ClienteCulturasCarregadas(this.culturas);

  @override
  List<Object?> get props => [culturas];
}

final class ClienteCulturaRelacionada extends ClienteState {
  final List<ClienteCulturaRelacaoModel> relacoes;

  const ClienteCulturaRelacionada(this.relacoes);

  @override
  List<Object?> get props => [relacoes];
}

final class ClienteErro extends ClienteState {
  final String mensagem;

  const ClienteErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}

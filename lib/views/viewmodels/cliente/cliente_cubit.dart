import 'package:farmtracker/databases/local/repositories/cliente_cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/cliente_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/endereco_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/lote_cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/lote_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/projeto_local_repository.dart';
import 'package:farmtracker/databases/models/response/cliente_response_model.dart';
import 'package:farmtracker/databases/models/response/cultura_response_model.dart';
import 'package:farmtracker/databases/models/response/endereco_response_model.dart';
import 'package:farmtracker/databases/models/response/projeto_response_model.dart';
import 'package:farmtracker/domains/models/cliente_cultura_model.dart';
import 'package:farmtracker/domains/models/cliente_cultura_relacao_model.dart';
import 'package:farmtracker/domains/models/cliente_model.dart';
import 'package:farmtracker/domains/models/cultura_model.dart';
import 'package:farmtracker/domains/models/lote_cultura_model.dart';
import 'package:farmtracker/domains/models/lote_model.dart';
import 'package:farmtracker/domains/models/projeto_model.dart';
import 'package:farmtracker/domains/repositories/cliente/cliente_repository.dart';
import 'package:farmtracker/domains/repositories/cultura/cultura_repository.dart';
import 'package:farmtracker/domains/repositories/endereco/endereco_repository.dart';
import 'package:farmtracker/views/viewmodels/cliente/cliente_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ClienteCubit extends Cubit<ClienteState> {
  final ClienteRepository _clienteRepository;
  final ClienteLocalRepository _clienteLocalRepository;
  final CulturaRepository _culturaRepository;
  final CulturaLocalRepository _culturaLocalRepository;
  final ClienteCulturaLocalRepository _clienteCulturaLocalRepository;
  final EnderecoLocalRepository _enderecoLocalRepository;
  final EnderecoRepository _enderecoRepository;
  final ProjetoLocalRepository _projetoLocalRepository;
  final LoteLocalRepository _loteLocalRepository;
  final LoteCulturaLocalRepository _loteCulturaLocalRepository;

  ClienteCubit(
    this._clienteRepository,
    this._culturaRepository,
    this._culturaLocalRepository,
    this._clienteCulturaLocalRepository,
    this._clienteLocalRepository,
    this._enderecoLocalRepository,
    this._enderecoRepository,
    this._projetoLocalRepository,
    this._loteLocalRepository,
    this._loteCulturaLocalRepository,
  ) : super(const ClienteInitial());

  Future<void> sincronizarClientesSeNecessario(DateTime dataReferencia) async {
    emit(const ClienteLoading());

    final bool jaSincronizado = await _hasSyncNearDate(dataReferencia);
    if (jaSincronizado) {
      emit(const ClienteSincronizado());
      return;
    }

    final result = await _clienteRepository.syncClients(dataReferencia);
    await result.fold(
      (cliente) async {
        await _gravarCarteiraCliente(cliente);
        await _gravarCarteiraProjeto(cliente.projetos.toMapModel(), cliente.uuid);
        await _gravarCarteiraCultura(cliente.uuid);
        await _gravarCarteiraEnderecoCliente(cliente);
        await _registrarSincronizacao(dataReferencia);
        emit(const ClienteSincronizado());
      },
      (failure) {
        emit(const ClienteErro('Falha ao sincronizar clientes.'));
      },
    );
  }

  Future<void> baixarCarteira(String usuario) async {
    emit(const ClienteLoading());

    final result = await _clienteRepository.getClientes(usuario);
    await result.fold(
      (clientes) async {
        for (final cliente in clientes) {
          await _gravarCarteiraCliente(cliente);
          await _gravarCarteiraProjeto(cliente.projetos.toMapModel(), cliente.uuid);
          await _gravarCarteiraCultura(cliente.uuid);
          await _gravarCarteiraEnderecoCliente(cliente);
        }
        emit(const ClienteSincronizado());
      },
      (failure) {
        emit(const ClienteErro('Falha ao baixar carteira de clientes.'));
      },
    );
  }

  Future<void> obterRelacaoClientes() async {
    emit(const ClienteLoading());

    final result = await _clienteLocalRepository.getClientes();
    result.fold(
      (clientes) async {
        final List<ClienteModel> clientesComEndereco = [];
        for (final cliente in clientes) {
          final enderecoResult = await _enderecoLocalRepository.obterPorCliente(cliente.uuid);
          enderecoResult.fold(
            (enderecos) {
              if (enderecos.isNotEmpty) {
                clientesComEndereco.add(cliente.copyWith(enderecos: enderecos));
              } else {
                clientesComEndereco.add(cliente);
              }
            },
            (_) => clientesComEndereco.add(cliente),
          );
        }
        emit(ClienteRelacaoCarregada(clientesComEndereco));
      },
      (_) => emit(const ClienteErro('Falha ao carregar relação de clientes.')),
    );
  }

  Future<void> obterClientePorUuid(String uuid) async {
    final result = await _clienteLocalRepository.getClientePorUuid(uuid);
    result.fold(
      (response) async {
        if (response.uuid.isNotEmpty) {
          ClienteModel cliente = response.toModel();
          final enderecoResult = await _enderecoLocalRepository.obterPorCliente(cliente.uuid);
          enderecoResult.fold(
            (enderecos) {
              if (enderecos.isNotEmpty) {
                cliente = cliente.copyWith(enderecos: enderecos);
              }
            },
            (_) {},
          );
          emit(ClienteCarregado(cliente));
        }
      },
      (_) => emit(const ClienteErro('Falha ao carregar cliente.')),
    );
  }

  Future<void> gravarCliente(ClienteModel cliente, {bool novoCliente = false}) async {
    if (novoCliente) {
      final result = await _clienteLocalRepository.gravar(cliente);
      result.fold(
        (success) {
          if (success) emit(ClienteGravadoSucesso(cliente));
        },
        (_) => emit(const ClienteErro('Falha ao gravar cliente.')),
      );
    } else {
      final result = await _clienteLocalRepository.atualizar(cliente);
      result.fold(
        (_) => emit(ClienteGravadoSucesso(cliente)),
        (_) => emit(const ClienteErro('Falha ao atualizar cliente.')),
      );
    }
  }

  String criarIdentificadorCliente() => const Uuid().v4();

  void atualizarFluxo(ProjectoStateFlow fluxo, {String? projeto, String? lote}) {
    emit(ClienteFluxoAtualizado(fluxo: fluxo, projeto: projeto, lote: lote));
  }

  void inicializarFluxo() {
    emit(const ClienteFluxoAtualizado(fluxo: ProjectoStateFlow.projeto));
  }

  Future<void> gravarClienteCultura({
    required String cliente,
    required String cultura,
    required double area,
    required String lote,
    required String projeto,
  }) async {
    final clienteCultura = ClienteCulturaModel(
      cliente: cliente,
      cultura: cultura,
      area: area,
      projeto: projeto,
      lote: lote,
    );
    await _clienteCulturaLocalRepository.gravar(clienteCultura);
  }

  Future<void> alterarClienteCultura({
    required String cliente,
    required String cultura,
    required double area,
    required String lote,
    required String projeto,
  }) async {
    final clienteCultura = ClienteCulturaModel(
      cliente: cliente,
      cultura: cultura,
      area: area,
      projeto: projeto,
      lote: lote,
    );
    await _clienteCulturaLocalRepository.alterar(clienteCultura);
  }

  void relacionarClienteCultura(ClienteCulturaModel clienteCultura, CulturaModel cultura) {
    final relacao = ClienteCulturaRelacaoModel(
      idCliente: clienteCultura.cliente,
      idCultura: clienteCultura.cultura,
      nomeCultura: cultura.nome,
      descricaoCultura: cultura.descricao,
      areaCultura: clienteCultura.area,
    );
    emit(ClienteCulturaRelacionada([relacao]));
  }

  Future<void> obterClienteCulturas({required String cliente}) async {
    final result = await _clienteCulturaLocalRepository.obterCulturasPorCliente(cliente);
    result.fold(
      (culturas) => emit(ClienteCulturasCarregadas(culturas)),
      (_) => emit(const ClienteCulturasCarregadas([])),
    );
  }

  void limparDadosMemoria() {
    emit(const ClienteInitial());
  }

  // ── Helpers privados ──────────────────────────────────────────────────────

  Future<bool> _hasSyncNearDate(DateTime referenceDate) async {
    final result = await _clienteLocalRepository.hasSyncNearDate(referenceDate);
    return result.fold((success) => success, (_) => false);
  }

  Future<void> _registrarSincronizacao(DateTime data) async {
    await _clienteLocalRepository.registrarSincronizacao(data);
  }

  Future<void> _gravarCarteiraCliente(ClienteResponseModel cliente) async {
    await _clienteLocalRepository.gravar(cliente.toModel());
  }

  Future<void> _gravarCarteiraProjeto(List<ProjetoModel> projetos, String clienteId) async {
    for (final projeto in projetos) {
      await _gravarCarteiraLote(projeto.lotes ?? [], projeto.uuid);
      await _projetoLocalRepository.gravar(projeto.copyWith(clienteId: clienteId));
    }
  }

  Future<void> _gravarCarteiraLote(List<LoteModel> lotes, String projetoId) async {
    for (final lote in lotes) {
      await _gravarCarteiraLoteCultura(lote.culturas ?? [], lote.uuid);
      await _loteLocalRepository.gravar(lote.copyWith(projeto: projetoId));
    }
  }

  Future<void> _gravarCarteiraLoteCultura(
    List<LoteCulturaModel> loteCulturas,
    String loteId,
  ) async {
    for (final loteCultura in loteCulturas) {
      await _loteCulturaLocalRepository.gravar(loteCultura.copyWith(lote: loteId));
    }
  }

  Future<void> _gravarCarteiraCultura(String clienteId) async {
    final result = await _culturaRepository.baixarCulturas(clienteId);
    await result.fold(
      (culturas) async {
        for (final cultura in culturas) {
          await _culturaLocalRepository.gravar(cultura.toModel());
        }
      },
      (_) async {},
    );
  }

  Future<void> _gravarCarteiraEnderecoCliente(ClienteResponseModel cliente) async {
    final result = await _enderecoRepository.obterPorCliente(cliente.uuid);
    await result.fold(
      (enderecos) async {
        for (final endereco in enderecos) {
          await _enderecoLocalRepository.gravar(endereco.toModel());
        }
      },
      (_) async {},
    );
  }
}

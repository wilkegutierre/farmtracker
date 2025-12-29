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
import 'package:farmtracker/views/viewmodels/cliente/cliente_data.dart';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';

enum ProjectoStateFlow { projeto, lote, cultura }

class ClienteViewmodel extends ChangeNotifier {
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

  ClienteViewmodel(
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
  );

  final data = ClienteData();

  Future<void> baixarCarteira(String usuario) async {
    data.isLoading = true;
    notifyListeners();

    final result = await _clienteRepository.getClientes(usuario);
    await result.fold(
      (success) async {
        final clientes = success;
        for (var cliente in clientes) {
          await _gravarCarteiraCliente(cliente);
          await _gravarCarteiraProjeto(cliente.projetos.toMapModel(), cliente.uuid);
          await _gravarCarteiraCultura(cliente.uuid);
          await _gravarCarteiraEnderecoCliente(cliente);
        }
        data.isLoading = false;
        notifyListeners();
      },
      (failure) {
        data.isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> _gravarCarteiraCliente(ClienteResponseModel cliente) async {
    await _clienteLocalRepository.gravar(cliente.toModel());
  }

  Future<void> _gravarCarteiraProjeto(List<ProjetoModel> projetos, String clienteId) async {
    for (var projeto in projetos) {
      await _gravarCarteiraLote(projeto.lotes ?? [], projeto.uuid);
      await _projetoLocalRepository.gravar(projeto.copyWith(clienteId: clienteId));
    }
  }

  Future<void> _gravarCarteiraLote(List<LoteModel> lotes, String projeto) async {
    for (var lote in lotes) {
      await _gravarCarteiraLoteCultura(lote.culturas ?? [], lote.uuid);
      await _loteLocalRepository.gravar(lote.copyWith(projeto: projeto));
    }
  }

  Future<void> _gravarCarteiraLoteCultura(List<LoteCulturaModel> loteCulturas, String loteId) async {
    for (var loteCultura in loteCulturas) {
      await _loteCulturaLocalRepository.gravar(loteCultura.copyWith(lote: loteId));
    }
  }

  Future<void> _gravarCarteiraCultura(String cliente) async {
    await _culturaRepository.baixarCulturas(cliente).fold((success) async {
      for (var cultura in success) {
        await _culturaLocalRepository.gravar(cultura.toModel());
      }
    }, (failure) => Failure(failure));
  }

  Future<void> _gravarCarteiraEnderecoCliente(ClienteResponseModel cliente) async {
    final result = await _enderecoRepository.obterPorCliente(cliente.uuid);
    result.fold((success) async {
      for (var endereco in success) {
        await _enderecoLocalRepository.gravar(endereco.toModel());
      }
    }, (failure) => Failure(failure));
  }

  Future<void> baixarClientes(String usuario) async {
    final result = await _clienteRepository.getClientes(usuario);
    await result.fold((success) async {
      for (var cliente in success) {
        data.clientes = success.toMapModel();
        await _clienteLocalRepository.gravar(cliente.toModel());
      }
      data.isLoading = true;
    }, (failure) {});
    notifyListeners();
  }

  Future<void> obterClientePorUuid(String uuid) async {
    final result = await _clienteLocalRepository.getClientePorUuid(uuid);
    result.fold((success) async {
      if (success.uuid.isNotEmpty) {
        data.cliente = success.toModel();
        final result = await _enderecoLocalRepository.obterPorCliente(data.cliente!.uuid);
        result.fold((enderecos) {
          enderecos.isNotEmpty ? data.cliente!.copyWith(enderecos: enderecos) : [];
        }, (failure) => Failure(failure));
      }
    }, (failure) {});
    notifyListeners();
  }

  Future<void> obterRelacaoClientes() async {
    data.isLoading = true;
    final result = await _clienteLocalRepository.getClientes();
    result.fold((clientes) async {
      List<ClienteModel> clientesResult = [];
      for (var cliente in clientes) {
        final result = await _enderecoLocalRepository.obterPorCliente(cliente.uuid);
        result.fold((enderecos) {
          if (enderecos.isNotEmpty) {
            final clienteEnderecoAtualizado = cliente.copyWith(enderecos: enderecos);
            clientesResult.add(clienteEnderecoAtualizado);
          }
        }, (failure) => Failure(failure));
      }
      data.clientes = clientesResult;
      data.isLoading = false;
      notifyListeners();
    }, (failure) {});
  }

  Future<void> gravarCliente(ClienteModel cliente, {bool novoCliente = false}) async {
    if (novoCliente) {
      final result = await _clienteLocalRepository.gravar(cliente);
      result.fold(
        (success) {
          if (success) {
            data.clienteSelecinado = cliente;
          }
        },
        (failure) {
          // TODO(): tratar retorno de erro
        },
      );
    } else {
      final result = await _clienteLocalRepository.atualizar(cliente);
      result.fold((success) => Success(success), (failure) {
        // TODO(): tratar retorno de erro
      });
    }
    notifyListeners();
  }

  String criarIdentificadorCliente() => const Uuid().v4();

  void changeState(final Object? obj) {
    data.state = obj;
    notifyListeners();
  }

  void initializeState() {
    data.state = ProjectoStateFlow.projeto;
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
  }

  void relacionarClienteCultura(ClienteCulturaModel clienteCultura, CulturaModel cultura) {
    final clienteCulturaRelacao = ClienteCulturaRelacaoModel(
      idCliente: clienteCultura.cliente,
      idCultura: clienteCultura.cultura,
      nomeCultura: cultura.nome,
      descricaoCultura: cultura.descricao,
      areaCultura: clienteCultura.area,
    );
    data.clienteCulturaRelacao.clear();
    data.clienteCulturaRelacao.add(clienteCulturaRelacao);
    notifyListeners();
  }

  Future<void> obterClienteCulturas({required String cliente}) async {
    final result = await _clienteCulturaLocalRepository.obterCulturasPorCliente(cliente);
    result.fold((success) {
      data.clienteCulturas = success;
    }, (error) {});
  }

  void limparDadosMemoria() {
    data.clienteCultura = null;
    data.clienteCulturaRelacao = [];
    data.clienteCulturas = [];
  }
}

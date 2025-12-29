import 'package:farmtracker/databases/local/repositories/cultura_local_repository.dart';
import 'package:farmtracker/databases/models/response/cultura_response_model.dart';
import 'package:farmtracker/domains/models/cultura_model.dart';
import 'package:farmtracker/domains/repositories/cultura/cultura_repository.dart';
import 'package:farmtracker/views/viewmodels/cultura/cultura_data.dart';
import 'package:flutter/foundation.dart';

class CulturaViewmodel extends ChangeNotifier {
  final CulturaRepository _culturaRepository;
  final CulturaLocalRepository _culturaLocalRepository;

  CulturaViewmodel(this._culturaRepository, this._culturaLocalRepository);

  final data = CulturaData();

  Future<void> baixarCulturasCliente(String cliente) async {
    final result = await _culturaRepository.baixarCulturas(cliente);
    result.fold(
      (success) async {
        //data.culturas = success.toMapModel();
        for (var cultura in success) {
          await gravar(cultura.toModel());
        }
      },
      (failure) {
        debugPrint(failure.toString());
      },
    );
    notifyListeners();
  }

  Future<void> obterCulturaPorNome(String nome) async {
    final result = await _culturaLocalRepository.obterPorNome(nome);
    result.fold(
      (success) {
        data.culturas = success;
        notifyListeners();
      },
      (failure) {
        debugPrint(failure.toString());
      },
    );
  }

  Future<void> obterCulturaPorUuid(String uuid) async {
    final result = await _culturaLocalRepository.obterPorUuid(uuid);
    result.fold(
      (success) {
        data.cultura = success;
        notifyListeners();
      },
      (failure) {
        debugPrint(failure.toString());
      },
    );
  }

  Future<void> gravar(CulturaModel cultura) async {
    final result = await _culturaLocalRepository.gravar(cultura);
    result.fold(
      (success) {
        notifyListeners();
      },
      (failure) {
        debugPrint(failure.toString());
      },
    );
  }

  Future<void> culturas() async {
    final result = await _culturaLocalRepository.culturas();
    result.fold(
      (success) async {
        data.culturas = success;
        notifyListeners();
      },
      (failure) {
        debugPrint(failure.toString());
      },
    );
  }

  // Future<void> culturasCLiente({String? clienteInformado}) async {
  //   final result = await _culturaLocalRepository.culturas();
  //   result.fold(
  //     (success) async {
  //       final culturas = success;
  //       if (clienteInformado != null) {
  //         data.relacaoClienteCulturas = data.relacaoClienteCulturas.isEmpty
  //             ? await _relacionamentoClienteCultura(clienteInformado)
  //             : data.relacaoClienteCulturas;
  //         if (data.relacaoClienteCulturas.isNotEmpty) {
  //           for (int i = 0; i < culturas.length; i++) {
  //             for (var clienteCultura in data.relacaoClienteCulturas) {
  //               if ((culturas[i].uuid == clienteCultura.cultura) && (clienteCultura.cliente == clienteInformado)) {
  //                 final culturaComArea = culturas[i].copyWith(areaCultura: clienteCultura.area!);
  //                 culturas[i] = culturaComArea;
  //               }
  //             }
  //           }
  //         }
  //         data.culturas = culturas;
  //       } else {
  //         data.culturas = culturas;
  //       }
  //       notifyListeners();
  //     },
  //     (failure) {
  //       debugPrint(failure.toString());
  //     },
  //   );
  // }

  // Future<List<ClienteCulturaModel>> _relacionamentoClienteCultura(String cliente) async =>
  //     await _clienteCulturaLocalRepository.obterCulturasPorCliente(cliente).fold((success) => success, (failure) => []);

  // Future<void> registrarAreaCultura(int indexCultura, String areaCultura) async {
  //   final cultura = data.culturas![indexCultura].copyWith(areaCultura: double.parse(areaCultura));
  //   data.culturas![indexCultura] = cultura;
  //   if (data.culturasAreaCliente!.isEmpty) {
  //     data.culturasAreaCliente!.add(cultura);
  //   } else {
  //     final culturaSelecionada = data.culturasAreaCliente!.where((value) => value.uuid == cultura.uuid).firstOrNull;
  //     if (culturaSelecionada == null) {
  //       data.culturasAreaCliente!.add(cultura);
  //     } else {
  //       data.culturasAreaCliente!.removeWhere((cultura) => cultura.uuid == cultura.uuid);
  //       data.culturasAreaCliente!.add(cultura);
  //     }
  //   }
  //   notifyListeners();
  // }

  // Future<void> relacionarClienteCulturas(String cliente, List<ClienteCulturaModel> clienteCulturas) async {
  //   for (var item in clienteCulturas) {
  //     await _clienteCulturaLocalRepository.obterClienteCultura(item.cliente, item.cultura).fold((found) async {
  //       await _clienteCulturaLocalRepository.atualizar(item);
  //     }, (notFound) async {
  //       if (notFound.errorCode == Situacao.registroNaoEncontrado) {
  //         await _clienteCulturaLocalRepository.salvar(item);
  //         return;
  //       }
  //     });
  //   }
  // }

  // Future<void> relacaoClienteCulturas(String cliente) async {
  //   await _clienteCulturaLocalRepository.obterCulturasPorCliente(cliente).fold((success) async {
  //     for (var culturaCliente in success) {
  //       await _culturaLocalRepository.obterPorUuid(culturaCliente.cultura).fold((cultura) {
  //         data.culturasAreaCliente?.add(cultura.copyWith(areaCultura: culturaCliente.area));
  //       }, (failure) => Failure(failure));
  //     }
  //     notifyListeners();
  //   }, (failure) => null);
  // }

  // Future<void> adicionar({
  //   required String nome,
  //   required String descricao,
  //   required String lote,
  //   required String area,
  // }) async {
  //   final cultura = CulturaModel(
  //     uuid: const Uuid().v4(),
  //     nome: nome,
  //     descricao: descricao,
  //     lote: lote,
  //     urlImagem: '',
  //     areaCultura: double.parse(area),
  //   );
  //   await _culturaLocalRepository.salvar(cultura);
  //   notifyListeners();
  // }

  // Future<void> alterar({
  //   required String uuid,
  //   required String nome,
  //   required String descricao,
  //   required String lote,
  //   required String area,
  // }) async {
  //   final cultura = CulturaModel(
  //     uuid: uuid,
  //     nome: nome,
  //     descricao: descricao,
  //     lote: lote,
  //     urlImagem: '',
  //     areaCultura: double.parse(area),
  //   );
  //   await _culturaLocalRepository.alterar(cultura);
  //   notifyListeners();
  // }

  // void removerCulturaCliente(index) {
  //   data.culturasAreaCliente!.removeAt(index);
  //   notifyListeners();
  // }
}

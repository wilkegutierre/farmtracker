import 'package:farmtracker/databases/local/repositories/projeto_local_repository.dart';
import 'package:farmtracker/domains/models/projeto_model.dart';
import 'package:farmtracker/views/viewmodels/projeto/projeto_data.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ProjetoViewmodel extends ChangeNotifier {
  final ProjetoLocalRepository _projetoRepository;
  ProjetoViewmodel(this._projetoRepository);

  final data = ProjetoData();

  Future<void> buscarProjetos() async {
    await _projetoRepository.obterTodos().then((result) {
      result.fold(
        (success) {
          data.projetos = success;
        },
        (failure) {
          // Handle failure
        },
      );
    });
    notifyListeners();
  }

  Future<void> buscarProjetoPorUuid(String uuid) async {
    await _projetoRepository.obterPorUuid(uuid).then((result) {
      result.fold(
        (success) {
          // Handle success
        },
        (failure) {
          // Handle failure
        },
      );
    });
    notifyListeners();
  }

  Future<void> buscarPorCliente(String cliente) async {
    await _projetoRepository.obterPorCliente(cliente).then((result) {
      result.fold(
        (success) {
          data.projetos = success;
        },
        (failure) {
          // Handle failure
        },
      );
    });
    notifyListeners();
  }

  Future<void> adicionar(String cliente, String nome, String descricao) async {
    final projeto = ProjetoModel(uuid: const Uuid().v4(), clienteId: cliente, nome: nome, descricao: descricao);
    await _projetoRepository.gravar(projeto);
  }

  Future<void> alterar(String uuid, String cliente, String nome, String descricao) async {
    final projeto = ProjetoModel(uuid: uuid, clienteId: cliente, nome: nome, descricao: descricao);
    await _projetoRepository.alterar(projeto).then((result) {
      result.fold(
        (success) {
          if (kDebugMode) {
            print(success);
          }
          notifyListeners();
        },
        (failure) {
          // Handle failure
        },
      );
    });
    notifyListeners();
  }

  Future<void> apagar(String uuid) async {
    await _projetoRepository.apagar(uuid).then((result) {
      result.fold((success) {}, (failure) {});
    });
    notifyListeners();
  }

  Future<void> removerItem(int index) async {
    await _projetoRepository.apagar(data.projetos![index].uuid);
    data.projetos!.removeAt(index);
    notifyListeners();
  }
}

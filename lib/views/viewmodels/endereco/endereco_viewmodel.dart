import 'package:farmtracker/databases/local/repositories/endereco_local_repository.dart';
import 'package:farmtracker/databases/models/response/endereco_response_model.dart';
import 'package:farmtracker/domains/models/endereco_model.dart';
import 'package:farmtracker/domains/repositories/endereco/endereco_repository.dart';
import 'package:farmtracker/views/viewmodels/endereco/endereco_data.dart';
import 'package:flutter/foundation.dart';

class EnderecoViewmodel extends ChangeNotifier {
  final EnderecoRepository enderecoRepository;
  final EnderecoLocalRepository enderecoLocal;

  EnderecoViewmodel(this.enderecoRepository, this.enderecoLocal);

  final enderecoData = EnderecoData();

  Future<void> obterPorCliente(String cliente) async {
    final result = await enderecoRepository.obterPorCliente(cliente);
    result.fold(
      (success) async {
        enderecoData.enderecosModel = success.toMapModel();
        for (var endereco in success) {
          await enderecoLocal.gravar(endereco.toModel());
        }
      },
      (failure) {
        // Handle failure
      },
    );
    notifyListeners();
  }

  Future<void> obterPorUuid(String uuid) async {
    final result = await enderecoRepository.obterPorUuid(uuid);
    result.fold(
      (success) {
        enderecoData.enderecoModel = success.toModel();
      },
      (failure) {
        // Handle failure
      },
    );
    notifyListeners();
  }

  Future<void> gravarEndereco(EnderecoModel endereco, {bool novoCliente = false}) async {
    if (novoCliente) {
      await enderecoLocal.gravar(endereco);
    } else {
      await enderecoLocal.atualizar(endereco);
    }
  }
}

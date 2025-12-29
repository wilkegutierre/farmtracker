import 'package:farmtracker/databases/local/repositories/lote_local_repository.dart';
import 'package:farmtracker/domains/models/lote_model.dart';
import 'package:farmtracker/views/viewmodels/lote/lote_data.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class LoteViewmodel extends ChangeNotifier {
  final LoteLocalRepository _loteRepository;
  LoteViewmodel(this._loteRepository);
  final data = LoteData();

  Future<void> buscarPorProjeto(String projeto) async {
    await _loteRepository.obterPorProjeto(projeto).then((result) {
      result.fold((success) {
        data.lotes = success;
      }, (failure) => failure);
    });
    notifyListeners();
  }

  Future<void> adicionar(String projeto, String nome, String descricao) async {
    final lote = LoteModel(uuid: const Uuid().v4(), projeto: projeto, nome: nome, descricao: descricao);
    await _loteRepository.gravar(lote);
  }

  Future<void> alterar(String uuid, String projeto, String nome, String descricao) async {
    final lote = LoteModel(uuid: uuid, projeto: projeto, nome: nome, descricao: descricao);
    await _loteRepository.alterar(lote);
  }

  Future<void> removerItem(int index) async {
    await _loteRepository.apagar(data.lotes![index].uuid);
    data.lotes!.removeAt(index);
    notifyListeners();
  }
}

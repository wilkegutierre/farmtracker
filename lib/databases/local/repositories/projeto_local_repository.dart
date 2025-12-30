import 'package:farmtracker/domains/models/projeto_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ProjetoLocalRepository {
  AsyncResult<List<ProjetoModel>> obterTodos();
  AsyncResult<ProjetoModel> obterPorUuid(String uuid);
  AsyncResult<List<ProjetoModel>> obterPorCliente(String cliente);
  AsyncResult<bool> gravar(ProjetoModel projeto);
  AsyncResult<bool> alterar(ProjetoModel projeto);
  AsyncResult<bool> apagar(String uuid);
}

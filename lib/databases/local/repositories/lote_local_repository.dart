import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/domains/models/lote_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class LoteLocalRepository {
  AsyncResult<List<LoteModel>> obterTodos();
  AsyncResult<LoteModel> obterPorUuid(String uuid);
  AsyncResult<List<LoteModel>> obterPorProjeto(String projeto);
  AsyncResult<bool> gravar(LoteModel lote);
  AsyncResult<bool> alterar(LoteModel lote);
  AsyncResult<bool> apagar(String uuid);
}

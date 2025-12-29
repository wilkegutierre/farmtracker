import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/domains/models/cultura_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class CulturaLocalRepository {
  AsyncResult<bool> gravar(CulturaModel cultura);
  AsyncResult<bool> alterar(CulturaModel cultura);
  AsyncResult<List<CulturaModel>> culturas();
  AsyncResult<List<CulturaModel>> obterPorNome(String nome);
  AsyncResult<CulturaModel> obterPorUuid(String uuid);
}

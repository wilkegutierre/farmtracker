import 'package:farmtracker/domains/models/lote_cultura_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class LoteCulturaLocalRepository {
  AsyncResult<bool> gravar(LoteCulturaModel loteCulturaModel);
  AsyncResult<bool> atualizar(LoteCulturaModel loteCulturaModel);
  AsyncResult<List<LoteCulturaModel>> obterPorLote(String loteId);
  AsyncResult<LoteCulturaModel> obterPorLoteCultura(String loteId, String culturaId);
  AsyncResult<List<LoteCulturaModel>> obterTodos();
}

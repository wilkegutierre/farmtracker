import 'package:farmtracker/databases/models/response/cliente_response_model.dart';
import 'package:farmtracker/domains/models/cliente_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ClienteLocalRepository {
  AsyncResult<List<ClienteModel>> getClientes();
  AsyncResult<ClienteResponseModel> getClientePorUuid(String uuid);
  AsyncResult<ClienteResponseModel> getClientePorNome(String nome);
  AsyncResult<bool> gravar(ClienteModel cliente);
  AsyncResult<bool> atualizar(ClienteModel cliente);
  AsyncResult<int> getCount();
  AsyncResult<bool> hasSyncNearDate(DateTime referenceDate, {int toleranceDays = 0});
  AsyncResult<bool> registrarSincronizacao(DateTime data);
}

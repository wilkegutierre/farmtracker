import 'package:farmtracker/databases/models/response/cliente_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ClienteRepository {
  AsyncResult<List<ClienteResponseModel>> getClientes(String usuario);
  AsyncResult<ClienteResponseModel> getClientePorUuid(String uuid);
}

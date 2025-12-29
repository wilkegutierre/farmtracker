import 'package:farmtracker/databases/models/response/cliente_response_model.dart';
import 'package:result_dart/result_dart.dart';

import '../../errors/app_failure_interface.dart';

abstract interface class ClienteService {
  AsyncResult<List<ClienteResponseModel>> getClientes(String userUuid);
  AsyncResult<ClienteResponseModel> getClientePorUuid(String uuid);
}

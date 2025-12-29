import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/models/response/endereco_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class EnderecoService {
  AsyncResult<List<EnderecoResponseModel>> obterPorCliente(String cliente);
  AsyncResult<EnderecoResponseModel> obterPorUuid(String uuid);
}

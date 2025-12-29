import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/models/response/cliente_response_model.dart';
import 'package:farmtracker/databases/services/cliente/cliente_service.dart';
import 'package:farmtracker/domains/repositories/cliente/cliente_repository.dart';
import 'package:result_dart/result_dart.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteService service;

  ClienteRepositoryImpl(this.service);

  @override
  AsyncResult<List<ClienteResponseModel>> getClientes(String usuario) async {
    try {
      return await service.getClientes(usuario).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternetConnectionError(message: e.toString()));
    }
  }

  @override
  AsyncResult<ClienteResponseModel> getClientePorUuid(String uuid) async {
    try {
      return await service.getClientePorUuid(uuid).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternetConnectionError(message: e.toString()));
    }
  }
}

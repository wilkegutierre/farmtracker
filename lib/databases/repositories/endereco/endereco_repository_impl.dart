import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/models/response/endereco_response_model.dart';
import 'package:farmtracker/databases/services/endereco/endereco_service.dart';
import 'package:farmtracker/domains/repositories/endereco/endereco_repository.dart';
import 'package:result_dart/result_dart.dart';

class EnderecoRepositoryImpl implements EnderecoRepository {
  final EnderecoService service;

  EnderecoRepositoryImpl(this.service);

  @override
  AsyncResult<List<EnderecoResponseModel>> obterPorCliente(String cliente) async {
    try {
      return await service.obterPorCliente(cliente).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternetConnectionError(message: e.toString()));
    }
  }

  @override
  AsyncResult<EnderecoResponseModel> obterPorUuid(String uuid) async {
    try {
      return await service.obterPorUuid(uuid).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternetConnectionError(message: e.toString()));
    }
  }
}

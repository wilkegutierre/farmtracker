import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/databases/services/usuario/usuario_service.dart';
import 'package:farmtracker/domains/repositories/usuario/usuario_repository.dart';
import 'package:result_dart/result_dart.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioService service;

  UsuarioRepositoryImpl({required this.service});

  @override
  AsyncResult<UsuarioResponseModel> getUsuarioById(String uuid) async {
    try {
      return await service.getUsuarioById(uuid).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<UsuarioResponseModel> login(LoginUserRequestModel loginRequest) async {
    try {
      return await service.login(loginRequest).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }
}

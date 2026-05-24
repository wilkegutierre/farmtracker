import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/databases/services/usuario/usuario_service.dart';
import 'package:farmtracker/domains/models/auth_data.dart';
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
  AsyncResult<AuthData> login(LoginUserRequestModel loginRequest) async {
    try {
      final result = await service.login(loginRequest);
      return result.fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<AuthData> setPassword(LoginUserRequestModel loginRequest) async {
    try {
      final result = await service.setPassword(loginRequest);
      return result.fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }
}

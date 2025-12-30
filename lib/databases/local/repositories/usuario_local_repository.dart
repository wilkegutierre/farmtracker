import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/domains/models/usuario_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class UsuarioLocalRepository {
  AsyncResult<bool> login(LoginUserRequestModel loginRequest);
  AsyncResult<UsuarioResponseModel> obterUsuarioPorEmail(String email);
  AsyncResult<bool> gravarUsuario(UsuarioModel usuario);
}

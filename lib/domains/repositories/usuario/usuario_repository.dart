import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class UsuarioRepository {
  AsyncResult<UsuarioResponseModel> getUsuarioById(String uuid);
  AsyncResult<String> login(LoginUserRequestModel loginRequest);
  AsyncResult<String> setPassword(LoginUserRequestModel loginRequest);
}

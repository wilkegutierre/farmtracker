import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class UsuarioService {
  AsyncResult<UsuarioResponseModel> getUsuarioById(String uuid);
  AsyncResult<UsuarioResponseModel> login(LoginUserRequestModel loginRequest);
}

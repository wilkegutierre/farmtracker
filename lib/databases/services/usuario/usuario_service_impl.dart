import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/mocks/models/usuario_response_model_mock.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/mocks/services/base_service_mock.dart';
import 'package:farmtracker/databases/services/usuario/usuario_service.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class UsuarioServiceImpl with BaseServiceMockMixin implements UsuarioService {
  final HttpClientInterface _httpClient;

  UsuarioServiceImpl(this._httpClient);

  @override
  AsyncResult<UsuarioResponseModel> getUsuarioById(String uuid) async {
    try {
      return requestServiceMock(() async {
        final url = '${Enviroment.apiBaseUrl}/usuario/$uuid';
        return await _httpClient.get(url);
      }).fold(
        (success) {
          final Response(:body) = success;
          //return Success(UsuarioResponseModel.fromJson(json.decode(bodyMock)));
          return Success(getMockUsuario());
        },
        (failure) {
          return Failure(InternalServerError());
        },
      );
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<UsuarioResponseModel> login(LoginUserRequestModel loginRequest) async {
    try {
      return requestServiceMock(() async {
        final url = '${Enviroment.apiBaseUrl}/usuario/login';
        return await _httpClient.post(url, loginRequest.toJsonStringfy());
      }).fold(
        (success) {
          final Response(:body) = success;
          //return Success(UsuarioResponseModel.fromJson(json.decode(bodyMock)));
          return Success(getMockUsuario());
        },
        (failure) {
          return Failure(InternalServerError());
        },
      );
    } catch (e) {
      return Failure(InternalServerError());
    }
  }
}

import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/mocks/models/endereco_response_model_mock.dart';
import 'package:farmtracker/databases/models/response/endereco_response_model.dart';
import 'package:farmtracker/databases/services/endereco/endereco_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/mocks/services/base_service_mock.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class EnderecoServiceImpl with BaseServiceMockMixin implements EnderecoService {
  final HttpClientInterface _httpClient;

  EnderecoServiceImpl(this._httpClient);

  @override
  AsyncResult<List<EnderecoResponseModel>> obterPorCliente(String cliente) async {
    try {
      return requestServiceMock(() async {
        final url = '${Enviroment.apiBaseUrl}/endereco_por_cliente/$cliente';
        return await _httpClient.get(url);
      }).fold(
        (success) {
          final Response(:body) = success;
          // Map<String, dynamic> element = jsonDecode(body);
          // List<EnderecoResponseModel> culturasResult = [];
          // for (var item in element as List) {
          //   culturasResult.add(EnderecoResponseModel.fromJson(item));
          // }
          //return Success(culturasResult);
          List<EnderecoResponseModel> enderecosCliente = [];
          for (var endereco in getMockEnderecos()) {
            if (endereco.pessoa.trim() == cliente) {
              enderecosCliente.add(endereco);
              return Success(enderecosCliente);
            }
          }
          return Failure(InternalServerError());
        },
        (failure) {
          return Failure(failure);
        },
      );
    } catch (error) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<EnderecoResponseModel> obterPorUuid(String uuid) async {
    try {
      return requestServiceMock(() async {
        final url = '${Enviroment.apiBaseUrl}/endereco/$uuid';
        return await _httpClient.get(url);
      }).fold(
        (success) {
          final Response(:body) = success;
          return Success(getMockEndereco());
          //return Success(CulturaResponseModel.fromJson(json.decode(body)));
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

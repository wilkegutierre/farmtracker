import 'package:http/http.dart' as http;

import 'http_interface.dart';

class CustomHttpClient implements HttpClientInterface {
  @override
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    return http
        .get(
          Uri.parse(url),
          headers: headers, //Aqui é um dicionário com as chaves necessárias para fazer a requisição
        )
        .timeout(const Duration(seconds: 2));
  }

  @override
  Future<dynamic> post(String url, String body,
      {Map<String, String>? headers = const {'Content-Type': 'application/json; charset=UTF-8'}}) {
    return http
        .post(
          Uri.parse(url),
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 2));
  }

  @override
  Future<dynamic> put(String url, String body,
      {Map<String, String>? headers = const {'Content-Type': 'application/json; charset=UTF-8'}}) {
    return http
        .put(
          Uri.parse(url),
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 2));
  }

  @override
  Future<dynamic> delete(String url, String body,
      {Map<String, String>? headers = const {'Content-Type': 'application/json; charset=UTF-8'}}) {
    return http
        .delete(
          Uri.parse(url),
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 2));
  }
}

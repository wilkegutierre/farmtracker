abstract class HttpClientInterface {
  Future<dynamic> get(String url, {Map<String, String>? headers});
  Future<dynamic> post(String url, String body, {Map<String, String>? headers});
  Future<dynamic> put(String url, String body, {Map<String, String>? headers});
  Future<dynamic> delete(String url, String body, {Map<String, String>? headers});
}

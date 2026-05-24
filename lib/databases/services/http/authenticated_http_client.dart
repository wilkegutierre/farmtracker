import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';

/// Cliente HTTP que injeta o token de acesso automaticamente nos headers.
class AuthenticatedHttpClient implements HttpClientInterface {
  final HttpClientInterface _inner;
  final SessionManagerRepository _sessionManager;

  AuthenticatedHttpClient(this._inner, this._sessionManager);

  static const List<String> _publicPathSegments = [
    '/user/auth/login',
    '/user/auth/set-password',
  ];

  bool _isPublicRequest(String url) {
    return _publicPathSegments.any(url.contains);
  }

  Future<Map<String, String>> _mergeHeaders(String url, Map<String, String>? headers) async {
    final Map<String, String> merged = Map<String, String>.from(headers ?? {});

    if (_isPublicRequest(url)) {
      return merged;
    }

    final String? token = await _sessionManager.getAccessToken();
    if (token == null || token.isEmpty) {
      return merged;
    }

    final String tokenType = await _sessionManager.getTokenType();
    merged['Authorization'] = '$tokenType $token';
    return merged;
  }

  @override
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    return _inner.get(url, headers: await _mergeHeaders(url, headers));
  }

  @override
  Future<dynamic> post(
    String url,
    String body, {
    Map<String, String>? headers = const {'Content-Type': 'application/json; charset=UTF-8'},
  }) {
    return _mergeHeaders(url, headers).then(
      (merged) => _inner.post(url, body, headers: merged),
    );
  }

  @override
  Future<dynamic> put(
    String url,
    String body, {
    Map<String, String>? headers = const {'Content-Type': 'application/json; charset=UTF-8'},
  }) {
    return _mergeHeaders(url, headers).then(
      (merged) => _inner.put(url, body, headers: merged),
    );
  }

  @override
  Future<dynamic> delete(
    String url,
    String body, {
    Map<String, String>? headers = const {'Content-Type': 'application/json; charset=UTF-8'},
  }) {
    return _mergeHeaders(url, headers).then(
      (merged) => _inner.delete(url, body, headers: merged),
    );
  }
}

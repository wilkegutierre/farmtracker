import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persistência local do token e da expiração.
/// Se o token for JWT, a data de expiração pode ser inferida do payload (`exp`).
class SessionStorage {
  SessionStorage._();

  static const String _keyToken = 'session_auth_token';
  static const String _keyExpiresMs = 'session_auth_expires_at_ms';

  /// Há sessão válida: token presente e, se houver [exp], ainda não passou.
  static Future<bool> hasValidSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(_keyToken);
    if (token == null || token.isEmpty) return false;

    final int? expiresMs = prefs.getInt(_keyExpiresMs);
    if (expiresMs == null) {
      return true;
    }
    return DateTime.now().millisecondsSinceEpoch < expiresMs;
  }

  /// Salva o token. Se [expiresAt] for nulo, tenta obter `exp` de um JWT.
  static Future<void> save(String token, {DateTime? expiresAt}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);

    final DateTime? exp = expiresAt ?? _tryParseJwtExpiry(token);
    if (exp != null) {
      await prefs.setInt(_keyExpiresMs, exp.millisecondsSinceEpoch);
    } else {
      await prefs.remove(_keyExpiresMs);
    }
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyExpiresMs);
  }

  static DateTime? _tryParseJwtExpiry(String token) {
    try {
      final List<String> parts = token.split('.');
      if (parts.length != 3) return null;
      final String normalized = base64Url.normalize(parts[1]);
      final String payload = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> map = jsonDecode(payload) as Map<String, dynamic>;
      final Object? exp = map['exp'];
      if (exp is int) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    } catch (_) {}
    return null;
  }
}

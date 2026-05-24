import 'package:farmtracker/domains/models/auth_data.dart';

abstract interface class SessionManagerRepository {
  Future<void> saveSession(AuthData authData);
  Future<bool> isSessionValid();
  Future<void> clearSession();
  Future<String?> getAccessToken();
  Future<String> getTokenType();
}

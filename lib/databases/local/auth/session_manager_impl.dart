import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:farmtracker/domains/models/auth_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManagerImpl with BaseServiceMixin implements SessionManagerRepository {
  // Salva os dados assim que o login é realizado com sucesso
  @override
  Future<void> saveSession(AuthData authData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', authData.token);
    await prefs.setString('token_type', authData.tokenType);
    await prefs.setString('token_expires_at', authData.expiresAt.toIso8601String());
  }

  // Recupera os dados salvos e já valida se a sessão ainda está ativa
  @override
  Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAtStr = prefs.getString('token_expires_at');
    final token = prefs.getString('jwt_token');

    if (token == null || expiresAtStr == null) {
      return false; // Não tem login salvo
    }

    final expiresAt = DateTime.parse(expiresAtStr);

    // Se a hora atual passou da data de expiração, limpa a sessão e retorna falso
    if (DateTime.now().isAfter(expiresAt)) {
      await clearSession();
      return false;
    }

    return true; // Token guardado e perfeitamente válido!
  }

  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('token_type');
    await prefs.remove('token_expires_at');
  }
}

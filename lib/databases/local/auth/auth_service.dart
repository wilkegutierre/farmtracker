import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Padrão Singleton para garantir que só exista uma instância controlando a sessão
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Cache em memória (Rápido!)
  String? _token;
  DateTime? _expiresAt;

  String? get token => _token;

  // Carrega os dados do SharedPreferences para a memória RAM (Executado apenas 1 vez no início do app)
  Future<void> inicializarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
    final expiresStr = prefs.getString('token_expires_at');
    if (expiresStr != null) {
      _expiresAt = DateTime.parse(expiresStr);
    }
  }

  // Salva no disco e na memória ao mesmo tempo
  Future<void> salvarSessao(String token, DateTime expiresAt) async {
    _token = token;
    _expiresAt = expiresAt;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setString('token_expires_at', expiresAt.toIso8601String());
  }

  // A validação instantânea que você vai usar nas ações
  bool isSessaoValida() {
    if (_token == null || _expiresAt == null) return false;

    // Se a hora atual passou da expiração, a sessão caiu
    return DateTime.now().isBefore(_expiresAt!);
  }

  Future<void> logout() async {
    _token = null;
    _expiresAt = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

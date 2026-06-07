class AuthData {
  final String userId;
  final String token;
  final String tokenType;
  final DateTime expiresAt;

  AuthData({required this.userId, required this.token, required this.tokenType, required this.expiresAt});

  // Verifica se o token já expirou
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

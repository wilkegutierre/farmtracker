import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String get fileName {
    if (kDebugMode) {
      return '.env.dev';
    }
    return '.env';
  }

  static String get appTitle {
    return (dotenv.env['APP_TITLE'] ?? '').trim();
  }

  static String get apiKey {
    return (dotenv.env['API_KEY'] ?? 'API_KEY not specified').trim();
  }

  /// Base da API. No emulador Android, `localhost`/`127.0.0.1` apontam para o próprio
  /// emulador; o host da máquina é alcançável via `10.0.2.2` (substituído aqui). Em aparelho físico, prefira
  /// o IP da máquina na LAN (ex.: `http://192.168.x.x:8080/api`) em vez de localhost.
  static String get apiBaseUrl {
    String base = (dotenv.env['API_BASE_URL'] ?? 'API_BASE_URL not specified').trim();
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      base = base.replaceAll('localhost', '10.0.2.2').replaceAll('127.0.0.1', '10.0.2.2');
    }
    return base;
  }
}

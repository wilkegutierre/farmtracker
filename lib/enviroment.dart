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
    return dotenv.env['APP_TITLE'] ?? "";
  }

  static String get apiKey {
    return dotenv.env['API_KEY'] ?? "API_KEY not specified";
  }

  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? "API_BASE_URL not specified";
  }
}

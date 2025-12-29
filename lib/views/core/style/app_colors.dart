import 'package:flutter/material.dart';

class AppColors {
  // Cores principais do PriceMarket
  static const Color primaryTeal = Color(0xFF0CC9A5); // Cor do botão
  static const Color primaryTealDark = Color(0xFF2A5865); // Cor do PriceMarket
  static const Color primaryTealLight = Color(0xFF7FFFD4); // Teal claro

  // Cores neutras
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGray = Color(0xFF2C2C2C);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color borderDark = Color(0xFF404040);

  // Cores de fundo
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Cores de fundo Dark
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardBackgroundDark = Color(0xFF1E1E1E);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Cores de texto
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textLight = Color(0xFFBDBDBD);

  // Cores de texto Dark
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textLightDark = Color(0xFF808080);

  // Cores de estado
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryTeal, primaryTealDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

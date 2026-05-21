import 'package:flutter/material.dart';

/// Design System "The Organic Editorial" — color tokens.
/// Prefer [Theme.of(context).colorScheme] in widgets; these back the theme and edge cases.
class AppColors {
  AppColors._();

  // —— Brand ——
  static const Color primary = Color(0xFF286B33);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF81C784);
  static const Color onPrimaryContainer = Color(0xFF002106);

  static const Color secondary = Color(0xFF6F5A52);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE8DDD8);
  static const Color onSecondaryContainer = Color(0xFF2A1F1E);

  static const Color tertiary = Color(0xFF5B6300);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFE8EBCC);
  static const Color onTertiaryContainer = Color(0xFF1E1F00);

  // —— Surfaces (layering, no stroke dividers) ——
  static const Color surface = Color(0xFFF9F9F7);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF4F4F2);
  static const Color surfaceContainer = Color(0xFFEEEEEC);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E6);

  static const Color onSurface = Color(0xFF1A1C1B);
  static const Color onSurfaceVariant = Color(0xFF5C605E);

  static const Color outlineVariant = Color(0xFFC2C7C0);

  // —— Legacy names (same app, old teal branding) ——
  static const Color primaryTeal = primary;
  static const Color primaryTealDark = primary;
  static const Color primaryTealLight = primaryContainer;

  // —— Neutrals ——
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // —— Back-compat: maps to DS surfaces ——
  static const Color backgroundLight = surface;
  static const Color cardBackground = surfaceContainer;

  // —— Dark surfaces (editorial dark) ——
  static const Color backgroundDark = Color(0xFF121412);
  static const Color cardBackgroundDark = Color(0xFF1C1E1C);
  static const Color surfaceDark = Color(0xFF252725);
  static const Color borderDark = Color(0xFF3D403E);

  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color textLight = Color(0xFF9E9E9C);

  static const Color textPrimaryDark = Color(0xFFE8E8E6);
  static const Color textSecondaryDark = Color(0xFFB0B3B0);
  static const Color textLightDark = Color(0xFF808580);

  static const Color darkGray = Color(0xFF2C2E2C);
  static const Color lightGray = surfaceContainerHigh;
  static const Color mediumGray = onSurfaceVariant;

  // —— State ——
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFE65100);

  /// Ambient shadow: `0px 8px 24px rgba(26, 28, 27, 0.06)`
  static const Color ambientShadow = Color(0x0F1A1C1B);

  /// Ghost border: outline_variant @ 15% opacity
  static Color get ghostBorder => outlineVariant.withValues(alpha: 0.15);

  static const LinearGradient primaryCtaGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = primaryCtaGradient;
}

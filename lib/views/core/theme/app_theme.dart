import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static ColorScheme get _lightColorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHigh,
      outline: AppColors.outlineVariant,
      outlineVariant: AppColors.outlineVariant,
      error: AppColors.error,
      onError: AppColors.white,
    );
  }

  static ColorScheme get _darkColorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppColors.primaryContainer,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primaryContainer,
      onPrimary: AppColors.onPrimaryContainer,
      primaryContainer: const Color(0xFF1E4D26),
      onPrimaryContainer: AppColors.primaryContainer,
      secondary: const Color(0xFFD7C2B8),
      onSecondary: const Color(0xFF3E2E29),
      secondaryContainer: const Color(0xFF4A3F3A),
      onSecondaryContainer: const Color(0xFFE8DDD8),
      tertiary: const Color(0xFFC5CC7A),
      onTertiary: const Color(0xFF2E3200),
      tertiaryContainer: const Color(0xFF3D4200),
      onTertiaryContainer: AppColors.tertiaryContainer,
      surface: AppColors.backgroundDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerLowest: AppColors.backgroundDark,
      surfaceContainerLow: const Color(0xFF1C1E1C),
      surfaceContainer: AppColors.cardBackgroundDark,
      surfaceContainerHigh: AppColors.surfaceDark,
      surfaceContainerHighest: const Color(0xFF353835),
      outline: const Color(0xFF8E928E),
      outlineVariant: const Color(0xFF5C605E),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
    );
  }

  static ThemeData get lightTheme {
    final scheme = _lightColorScheme;
    final borderRadius = BorderRadius.circular(12.0);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      cardColor: scheme.surfaceContainer,
      dividerColor: Colors.transparent,
      splashFactory: InkSparkle.splashFactory,

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineSmall,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      textTheme: AppTextStyles.textTheme,

      dividerTheme: const DividerThemeData(color: Colors.transparent, thickness: 0, space: 0),

      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
        margin: EdgeInsets.zero,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
        floatingLabelStyle: AppTextStyles.labelMedium.copyWith(color: scheme.primary),
        border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: AppTextStyles.button.copyWith(color: scheme.onPrimary),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: AppTextStyles.button.copyWith(color: scheme.onPrimary),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.secondary,
          side: BorderSide(color: AppColors.ghostBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: scheme.onSecondaryContainer,
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.tertiaryContainer,
        foregroundColor: scheme.onTertiaryContainer,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      ),

      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: AppTextStyles.titleMedium,
        subtitleTextStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get darkTheme {
    final scheme = _darkColorScheme;
    final borderRadius = BorderRadius.circular(12.0);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      cardColor: scheme.surfaceContainer,
      dividerColor: Colors.transparent,
      splashFactory: InkSparkle.splashFactory,

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(color: scheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      textTheme: _darkTextTheme,

      dividerTheme: const DividerThemeData(color: Colors.transparent, thickness: 0, space: 0),

      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
        margin: EdgeInsets.zero,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: AppTextStyles.button.copyWith(color: scheme.onPrimary),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: AppTextStyles.button.copyWith(color: scheme.onPrimary),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.secondary,
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: scheme.onSecondaryContainer,
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.tertiaryContainer,
        foregroundColor: scheme.onTertiaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      ),

      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface),
        subtitleTextStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static TextTheme get _darkTextTheme {
    final on = AppColors.textPrimaryDark;
    final variant = AppColors.textSecondaryDark;
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: on),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: on),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: on),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: on),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: on),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: on),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: on),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: on),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: on),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: variant),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: variant),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: variant),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: on),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: on),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: variant),
    );
  }
}

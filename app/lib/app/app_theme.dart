import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Paleta raw — tokens diretos do design spec
// ---------------------------------------------------------------------------
abstract final class AppPalette {
  // Surfaces
  static const surface              = Color(0xFFF8F9FF);
  static const surfaceDim           = Color(0xFFCBDBF5);
  static const surfaceBright        = Color(0xFFF8F9FF);
  static const surfaceContainerLowest  = Color(0xFFFFFFFF);
  static const surfaceContainerLow     = Color(0xFFEFF4FF);
  static const surfaceContainer        = Color(0xFFE5EEFF);
  static const surfaceContainerHigh    = Color(0xFFDCE9FF);
  static const surfaceContainerHighest = Color(0xFFD3E4FE);
  static const onSurface            = Color(0xFF0B1C30);
  static const onSurfaceVariant     = Color(0xFF45464D);
  static const inverseSurface       = Color(0xFF213145);
  static const inverseOnSurface     = Color(0xFFEAF1FF);

  // Outlines
  static const outline              = Color(0xFF76777D);
  static const outlineVariant       = Color(0xFFC6C6CD);
  static const surfaceTint          = Color(0xFF565E74);

  // Primary — Deep Navy
  static const primary              = Color(0xFF000000);
  static const onPrimary            = Color(0xFFFFFFFF);
  static const primaryContainer     = Color(0xFF131B2E);
  static const onPrimaryContainer   = Color(0xFF7C839B);
  static const inversePrimary       = Color(0xFFBEC6E0);

  // Secondary — Emerald Green
  static const secondary            = Color(0xFF006C49);
  static const onSecondary          = Color(0xFFFFFFFF);
  static const secondaryContainer   = Color(0xFF6CF8BB);
  static const onSecondaryContainer = Color(0xFF00714D);

  // Tertiary — Action Blue
  static const tertiary             = Color(0xFF000000);
  static const onTertiary           = Color(0xFFFFFFFF);
  static const tertiaryContainer    = Color(0xFF001A42);
  static const onTertiaryContainer  = Color(0xFF3980F4);

  // Error
  static const error                = Color(0xFFBA1A1A);
  static const onError              = Color(0xFFFFFFFF);
  static const errorContainer       = Color(0xFFFFDAD6);
  static const onErrorContainer     = Color(0xFF93000A);
}

// ---------------------------------------------------------------------------
// Paleta dark — derivada do brand (navy / emerald / action-blue)
// ---------------------------------------------------------------------------
abstract final class AppPaletteDark {
  static const surface              = Color(0xFF0D1117);
  static const surfaceContainerLowest  = Color(0xFF090D12);
  static const surfaceContainerLow     = Color(0xFF111822);
  static const surfaceContainer        = Color(0xFF161E2C);
  static const surfaceContainerHigh    = Color(0xFF1C2535);
  static const surfaceContainerHighest = Color(0xFF222D3F);
  static const onSurface            = Color(0xFFE2EBF5);
  static const onSurfaceVariant     = Color(0xFF8A95A3);
  static const inverseSurface       = Color(0xFFEAF1FF);
  static const inverseOnSurface     = Color(0xFF213145);

  static const outline              = Color(0xFF2E3A4E);
  static const outlineVariant       = Color(0xFF1E2A3A);

  static const primary              = Color(0xFFBEC6E0);
  static const onPrimary            = Color(0xFF131B2E);
  static const primaryContainer     = Color(0xFF1E2740);
  static const onPrimaryContainer   = Color(0xFFDDE5FF);
  static const inversePrimary       = Color(0xFF131B2E);

  static const secondary            = Color(0xFF4EDEA3);
  static const onSecondary          = Color(0xFF002113);
  static const secondaryContainer   = Color(0xFF005236);
  static const onSecondaryContainer = Color(0xFF6FFBBE);

  static const tertiary             = Color(0xFFADC6FF);
  static const onTertiary           = Color(0xFF001A42);
  static const tertiaryContainer    = Color(0xFF004395);
  static const onTertiaryContainer  = Color(0xFFD8E2FF);

  static const error                = Color(0xFFFFB4AB);
  static const onError              = Color(0xFF690005);
  static const errorContainer       = Color(0xFF93000A);
  static const onErrorContainer     = Color(0xFFFFDAD6);
}

// ---------------------------------------------------------------------------
// Tipografia — Inter + JetBrains Mono
// ---------------------------------------------------------------------------
abstract final class AppTypography {
  static TextTheme _base(Color textColor) => TextTheme(
        // display-lg  48/700/-0.02em
        displayLarge: GoogleFonts.inter(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          height: 56 / 48,
          letterSpacing: -0.02 * 48,
          color: textColor,
        ),
        // headline-lg  32/600/-0.01em
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 40 / 32,
          letterSpacing: -0.01 * 32,
          color: textColor,
        ),
        // headline-md  24/600
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 32 / 24,
          color: textColor,
        ),
        // headline-lg-mobile  24/600  (reutiliza headlineSmall)
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 32 / 24,
          color: textColor,
        ),
        // body-lg  18/400
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 28 / 18,
          color: textColor,
        ),
        // body-md  16/400
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 24 / 16,
          color: textColor,
        ),
        // body-sm  14/400
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
          color: textColor,
        ),
        // label-md  14/600
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 20 / 14,
          color: textColor,
        ),
        // label-sm  12/500
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
          color: textColor,
        ),
      );

  static TextTheme get light => _base(AppPalette.onSurface);
  static TextTheme get dark  => _base(AppPaletteDark.onSurface);

  /// mono-md — JetBrains Mono 14/400, para IDs e valores numéricos.
  static TextStyle get monoMd => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      );
}

// ---------------------------------------------------------------------------
// Constantes de shape e elevação
// ---------------------------------------------------------------------------
abstract final class AppShape {
  static const radiusSm  = 2.0;   // status badges
  static const radius    = 4.0;   // botões, inputs
  static const radiusMd  = 6.0;
  static const radiusLg  = 8.0;   // cards, modais
  static const radiusXl  = 12.0;
  static const radiusFull = 9999.0;

  static const borderRadius    = BorderRadius.all(Radius.circular(radius));
  static const borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
}

// ---------------------------------------------------------------------------
// Temas
// ---------------------------------------------------------------------------
abstract final class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      // Primary
      primary: AppPalette.primary,
      onPrimary: AppPalette.onPrimary,
      primaryContainer: AppPalette.primaryContainer,
      onPrimaryContainer: AppPalette.onPrimaryContainer,
      inversePrimary: AppPalette.inversePrimary,
      // Secondary
      secondary: AppPalette.secondary,
      onSecondary: AppPalette.onSecondary,
      secondaryContainer: AppPalette.secondaryContainer,
      onSecondaryContainer: AppPalette.onSecondaryContainer,
      // Tertiary (Action Blue)
      tertiary: AppPalette.tertiary,
      onTertiary: AppPalette.onTertiary,
      tertiaryContainer: AppPalette.tertiaryContainer,
      onTertiaryContainer: AppPalette.onTertiaryContainer,
      // Error
      error: AppPalette.error,
      onError: AppPalette.onError,
      errorContainer: AppPalette.errorContainer,
      onErrorContainer: AppPalette.onErrorContainer,
      // Surface
      surface: AppPalette.surface,
      surfaceDim: AppPalette.surfaceDim,
      surfaceBright: AppPalette.surfaceBright,
      surfaceContainerLowest: AppPalette.surfaceContainerLowest,
      surfaceContainerLow: AppPalette.surfaceContainerLow,
      surfaceContainer: AppPalette.surfaceContainer,
      surfaceContainerHigh: AppPalette.surfaceContainerHigh,
      surfaceContainerHighest: AppPalette.surfaceContainerHighest,
      onSurface: AppPalette.onSurface,
      onSurfaceVariant: AppPalette.onSurfaceVariant,
      inverseSurface: AppPalette.inverseSurface,
      onInverseSurface: AppPalette.inverseOnSurface,
      // Outline
      outline: AppPalette.outline,
      outlineVariant: AppPalette.outlineVariant,
      surfaceTint: AppPalette.surfaceTint,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      textTheme: AppTypography.light,
      scaffoldBackgroundColor: AppPalette.surface,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppPalette.surfaceContainerLowest,
        foregroundColor: AppPalette.onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppPalette.surfaceContainerLow,
        indicatorColor: AppPalette.surfaceContainerHigh,
        selectedIconTheme: const IconThemeData(color: AppPalette.primary),
        unselectedIconTheme: const IconThemeData(color: AppPalette.onSurfaceVariant),
        selectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppPalette.primary,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppPalette.onSurfaceVariant,
        ),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: AppPalette.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(),
      ),

      cardTheme: const CardThemeData(
        color: AppPalette.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppShape.borderRadiusLg,
          side: BorderSide(color: AppPalette.outlineVariant),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFFF1F5F9), // spec: separador de linhas em tabelas
        space: 1,
        thickness: 1,
      ),

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.surfaceContainerLowest,
        hintStyle: TextStyle(color: AppPalette.onSurfaceVariant),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppPalette.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPalette.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppPalette.onTertiaryContainer, // Action Blue
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPalette.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPalette.error, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppPalette.primary,
          foregroundColor: AppPalette.onPrimary,
          shape: const RoundedRectangleBorder(borderRadius: AppShape.borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.primary,
          backgroundColor: AppPalette.surfaceContainerLowest,
          side: const BorderSide(),
          shape: const RoundedRectangleBorder(borderRadius: AppShape.borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPalette.onSurface,
          shape: const RoundedRectangleBorder(borderRadius: AppShape.borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),

      listTileTheme: const ListTileThemeData(
        selectedTileColor: AppPalette.surfaceContainerHigh,
        selectedColor: AppPalette.primary,
        textColor: AppPalette.onSurface,
        iconColor: AppPalette.onSurfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: AppShape.borderRadius),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppPalette.inverseSurface,
        contentTextStyle: TextStyle(color: AppPalette.inverseOnSurface),
        shape: RoundedRectangleBorder(borderRadius: AppShape.borderRadiusLg),
        behavior: SnackBarBehavior.floating,
      ),

      chipTheme: const ChipThemeData(
        backgroundColor: AppPalette.surfaceContainerLow,
        selectedColor: AppPalette.surfaceContainerHigh,
        labelStyle: TextStyle(color: AppPalette.onSurface, fontSize: 12),
        side: BorderSide(color: AppPalette.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppShape.radiusSm)),
        ),
      ),
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppPaletteDark.primary,
      onPrimary: AppPaletteDark.onPrimary,
      primaryContainer: AppPaletteDark.primaryContainer,
      onPrimaryContainer: AppPaletteDark.onPrimaryContainer,
      inversePrimary: AppPaletteDark.inversePrimary,
      secondary: AppPaletteDark.secondary,
      onSecondary: AppPaletteDark.onSecondary,
      secondaryContainer: AppPaletteDark.secondaryContainer,
      onSecondaryContainer: AppPaletteDark.onSecondaryContainer,
      tertiary: AppPaletteDark.tertiary,
      onTertiary: AppPaletteDark.onTertiary,
      tertiaryContainer: AppPaletteDark.tertiaryContainer,
      onTertiaryContainer: AppPaletteDark.onTertiaryContainer,
      error: AppPaletteDark.error,
      onError: AppPaletteDark.onError,
      errorContainer: AppPaletteDark.errorContainer,
      onErrorContainer: AppPaletteDark.onErrorContainer,
      surface: AppPaletteDark.surface,
      surfaceContainerLowest: AppPaletteDark.surfaceContainerLowest,
      surfaceContainerLow: AppPaletteDark.surfaceContainerLow,
      surfaceContainer: AppPaletteDark.surfaceContainer,
      surfaceContainerHigh: AppPaletteDark.surfaceContainerHigh,
      surfaceContainerHighest: AppPaletteDark.surfaceContainerHighest,
      onSurface: AppPaletteDark.onSurface,
      onSurfaceVariant: AppPaletteDark.onSurfaceVariant,
      inverseSurface: AppPaletteDark.inverseSurface,
      onInverseSurface: AppPaletteDark.inverseOnSurface,
      outline: AppPaletteDark.outline,
      outlineVariant: AppPaletteDark.outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      textTheme: AppTypography.dark,
      scaffoldBackgroundColor: AppPaletteDark.surface,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppPaletteDark.surfaceContainerLow,
        foregroundColor: AppPaletteDark.onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppPaletteDark.surfaceContainerLow,
        indicatorColor: AppPaletteDark.surfaceContainerHigh,
        selectedIconTheme: const IconThemeData(color: AppPaletteDark.primary),
        unselectedIconTheme: const IconThemeData(color: AppPaletteDark.onSurfaceVariant),
        selectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppPaletteDark.primary,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppPaletteDark.onSurfaceVariant,
        ),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: AppPaletteDark.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(),
      ),

      cardTheme: const CardThemeData(
        color: AppPaletteDark.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppShape.borderRadiusLg,
          side: BorderSide(color: AppPaletteDark.outlineVariant),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppPaletteDark.outlineVariant,
        space: 1,
        thickness: 1,
      ),

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppPaletteDark.surfaceContainerLow,
        hintStyle: TextStyle(color: AppPaletteDark.onSurfaceVariant),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppPaletteDark.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPaletteDark.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppPaletteDark.onTertiaryContainer, // Action Blue dark
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPaletteDark.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPaletteDark.error, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppPaletteDark.primary,
          foregroundColor: AppPaletteDark.onPrimary,
          shape: const RoundedRectangleBorder(borderRadius: AppShape.borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPaletteDark.primary,
          backgroundColor: AppPaletteDark.surfaceContainerLow,
          side: const BorderSide(color: AppPaletteDark.primary),
          shape: const RoundedRectangleBorder(borderRadius: AppShape.borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPaletteDark.onSurface,
          shape: const RoundedRectangleBorder(borderRadius: AppShape.borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),

      listTileTheme: const ListTileThemeData(
        selectedTileColor: AppPaletteDark.surfaceContainerHigh,
        selectedColor: AppPaletteDark.primary,
        textColor: AppPaletteDark.onSurface,
        iconColor: AppPaletteDark.onSurfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: AppShape.borderRadius),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppPaletteDark.inverseSurface,
        contentTextStyle: TextStyle(color: AppPaletteDark.inverseOnSurface),
        shape: RoundedRectangleBorder(borderRadius: AppShape.borderRadiusLg),
        behavior: SnackBarBehavior.floating,
      ),

      chipTheme: const ChipThemeData(
        backgroundColor: AppPaletteDark.surfaceContainerLow,
        selectedColor: AppPaletteDark.surfaceContainerHigh,
        labelStyle: TextStyle(color: AppPaletteDark.onSurface, fontSize: 12),
        side: BorderSide(color: AppPaletteDark.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppShape.radiusSm)),
        ),
      ),
    );
  }
}

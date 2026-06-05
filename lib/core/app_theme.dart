import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Light Theme ───
  static const lightPrimary = Color(0xFF006C35);
  static const lightPrimaryHover = Color(0xFF00552A);
  static const lightPrimaryContainer = Color(0xFFD7F5E3);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightSecondary = Color(0xFF0F766E);
  static const lightSecondaryContainer = Color(0xFFD6F4F1);
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF1F5F9);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFDCE3EA);
  static const lightDivider = Color(0xFFE2E8F0);
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF475569);
  static const lightTextTertiary = Color(0xFF64748B);
  static const lightTextDisabled = Color(0xFF94A3B8);
  static const lightSuccess = Color(0xFF16A34A);
  static const lightSuccessContainer = Color(0xFFDCFCE7);
  static const lightWarning = Color(0xFFD97706);
  static const lightWarningContainer = Color(0xFFFEF3C7);
  static const lightError = Color(0xFFDC2626);
  static const lightErrorContainer = Color(0xFFFEE2E2);
  static const lightInfo = Color(0xFF2563EB);
  static const lightInfoContainer = Color(0xFFDBEAFE);
  static const lightShadow = Color(0x14000000);
  static const lightOverlay = Color(0x66000000);

  // ─── Dark Theme ───
  static const darkPrimary = Color(0xFF34D399);
  static const darkPrimaryHover = Color(0xFF10B981);
  static const darkPrimaryContainer = Color(0xFF052E1B);
  static const darkOnPrimary = Color(0xFFFFFFFF);
  static const darkSecondary = Color(0xFF2DD4BF);
  static const darkSecondaryContainer = Color(0xFF042F2E);
  static const darkBackground = Color(0xFF0B1220);
  static const darkSurface = Color(0xFF111827);
  static const darkSurfaceVariant = Color(0xFF1F2937);
  static const darkCard = Color(0xFF111827);
  static const darkBorder = Color(0xFF374151);
  static const darkDivider = Color(0xFF334155);
  static const darkTextPrimary = Color(0xFFF8FAFC);
  static const darkTextSecondary = Color(0xFFCBD5E1);
  static const darkTextTertiary = Color(0xFF94A3B8);
  static const darkTextDisabled = Color(0xFF64748B);
  static const darkSuccess = Color(0xFF22C55E);
  static const darkSuccessContainer = Color(0xFF052E16);
  static const darkWarning = Color(0xFFF59E0B);
  static const darkWarningContainer = Color(0xFF451A03);
  static const darkError = Color(0xFFEF4444);
  static const darkErrorContainer = Color(0xFF450A0A);
  static const darkInfo = Color(0xFF60A5FA);
  static const darkInfoContainer = Color(0xFF082F49);
  static const darkShadow = Color(0x40000000);
  static const darkOverlay = Color(0x99000000);

  // ─── Ticket Status Colors ───
  static const statusNew = Color(0xFF2563EB);
  static const statusInProgress = Color(0xFFF59E0B);
  static const statusDelayed = Color(0xFFDC2626);
  static const statusEscalated = Color(0xFF7C3AED);
  static const statusCompleted = Color(0xFF16A34A);

  // ─── KPI Colors ───
  static const kpiTotal = Color(0xFF006C35);
  static const kpiNew = Color(0xFF2563EB);
  static const kpiInProgress = Color(0xFFF59E0B);
  static const kpiEscalated = Color(0xFF7C3AED);
  static const kpiCompleted = Color(0xFF16A34A);
  static const kpiDelayed = Color(0xFFDC2626);
}

ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'IBMPlexSansArabic',
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,
    dividerColor: AppColors.lightDivider,
    shadowColor: AppColors.lightShadow,
    primaryColor: AppColors.lightPrimary,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      secondary: AppColors.lightSecondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.lightSecondaryContainer,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      error: AppColors.lightError,
      onError: Colors.white,
      errorContainer: AppColors.lightErrorContainer,
      outline: AppColors.lightBorder,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightCard,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        side: const BorderSide(color: AppColors.lightBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceVariant,
      hintStyle: TextStyle(
        fontFamily: 'IBMPlexSansArabic',
        fontSize: 14,
        color: AppColors.lightTextTertiary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
      thickness: 1,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightCard,
      indicatorColor: AppColors.lightPrimaryContainer,
    ),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'IBMPlexSansArabic',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.darkDivider,
    shadowColor: AppColors.darkShadow,
    primaryColor: AppColors.darkPrimary,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      secondary: AppColors.darkSecondary,
      onSecondary: Color(0xFF0B1220),
      secondaryContainer: AppColors.darkSecondaryContainer,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      error: AppColors.darkError,
      onError: Colors.white,
      errorContainer: AppColors.darkErrorContainer,
      outline: AppColors.darkBorder,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkCard,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        side: const BorderSide(color: AppColors.darkBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
      hintStyle: TextStyle(
        fontFamily: 'IBMPlexSansArabic',
        fontSize: 14,
        color: AppColors.darkTextTertiary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkCard,
      indicatorColor: AppColors.darkPrimaryContainer,
    ),
  );
}

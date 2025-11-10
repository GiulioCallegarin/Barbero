// import 'package:flutter/material.dart';

// ThemeData darkMode = ThemeData(
//   colorScheme: ColorScheme.dark(
//     surface: Colors.grey.shade900,
//     primary: Colors.grey.shade600,
//     secondary: Colors.grey.shade700,
//     tertiary: Colors.grey.shade800,
//     inversePrimary: Colors.grey.shade300,
//     error: Colors.grey.shade400,
//   ),
// );

import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6366F1),
    primaryContainer: Color(0xFFE0E7FF),
    secondary: Color(0xFF06B6D4),
    secondaryContainer: Color(0xFFCFFAFE),
    tertiary: Color(0xFF8B5CF6),
    tertiaryContainer: Color(0xFFEDE9FE),
    surface: Color(0xFFFAFAFA),
    surfaceContainerHighest: Color(0xFFE2E8F0),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: Colors.white,
    onSurface: Color(0xFF1E293B),
    outline: Color(0xFF94A3B8),
    outlineVariant: Color(0xFFCBD5E1),
    inversePrimary: Color(0xFFF1F5F9),
    inverseSurface: Color(0xFF1E293B),
    error: Color(0xFFDC2626),
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF),
    foregroundColor: Color(0xFF1E293B),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    shadowColor: Color(0x1A000000),
    titleTextStyle: TextStyle(
      color: Color(0xFF1E293B),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 4,
    shadowColor: Color(0x1A000000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6366F1),
      foregroundColor: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x4D6366F1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF6366F1),
      side: const BorderSide(color: Color(0xFF6366F1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF6366F1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDC2626)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFF64748B)),
    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
    prefixIconColor: const Color(0xFF64748B),
    suffixIconColor: const Color(0xFF64748B),
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFFE2E8F0), thickness: 1),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFF6366F1),
    unselectedItemColor: Color(0xFF94A3B8),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    titleTextStyle: TextStyle(
      color: Color(0xFF1E293B),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF1E293B),
    contentTextStyle: TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  chipTheme: const ChipThemeData(
    backgroundColor: Color(0xFFF1F5F9),
    selectedColor: Color(0xFF6366F1),
    labelStyle: TextStyle(color: Color(0xFF1E293B)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF6366F1);
      }
      return const Color(0xFF94A3B8);
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0x4D6366F1);
      }
      return const Color(0xFFCBD5E1);
    }),
  ),
);

// import 'package:flutter/material.dart';

// ThemeData lightMode = ThemeData(
//   colorScheme: ColorScheme.light(
//     surface: Colors.grey.shade300,
//     primary: Colors.grey.shade500,
//     secondary: Colors.grey.shade200,
//     tertiary: Colors.white,
//     inversePrimary: Colors.grey.shade900,
//     error: Colors.grey.shade900,
//   ),
// );

import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF6366F1),
    primaryContainer: Color(0xFF4F46E5),
    secondary: Color(0xFF06B6D4),
    secondaryContainer: Color(0xFF0891B2),
    tertiary: Color(0xFF8B5CF6),
    tertiaryContainer: Color(0xFF7C3AED),
    surface: Color(0xFF0F172A),
    surfaceContainerHighest: Color(0xFF334155),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: Colors.white,
    onSurface: Color(0xFFF1F5F9),
    outline: Color(0xFF64748B),
    outlineVariant: Color(0xFF475569),
    inversePrimary: Color(0xFF6366F1),
    inverseSurface: Color(0xFFF1F5F9),
    error: Color(0xFFEF4444),
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF020617),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F172A),
    foregroundColor: Color(0xFFF1F5F9),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      color: Color(0xFFF1F5F9),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFF1E293B),
    elevation: 8,
    shadowColor: Color(0x4D000000),
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
    fillColor: const Color(0xFF1E293B),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF475569)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF475569)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFEF4444)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
    hintStyle: const TextStyle(color: Color(0xFF64748B)),
    prefixIconColor: const Color(0xFF94A3B8),
    suffixIconColor: const Color(0xFF94A3B8),
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFF334155), thickness: 1),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0F172A),
    selectedItemColor: Color(0xFF6366F1),
    unselectedItemColor: Color(0xFF64748B),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFF1E293B),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    titleTextStyle: TextStyle(
      color: Color(0xFFF1F5F9),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF334155),
    contentTextStyle: TextStyle(color: Color(0xFFF1F5F9)),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  chipTheme: const ChipThemeData(
    backgroundColor: Color(0xFF1E293B),
    selectedColor: Color(0xFF6366F1),
    labelStyle: TextStyle(color: Color(0xFFF1F5F9)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF6366F1);
      }
      return const Color(0xFF64748B);
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0x4D6366F1);
      }
      return const Color(0xFF475569);
    }),
  ),
);

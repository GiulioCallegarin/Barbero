import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData experimentalMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFDC143C), // Crimson Red (più rosso)
    primaryContainer: Color(0xFFFF4757), // Rosso chiaro
    secondary: Color(0xFF32CD32), // Lime Green (meno acido)
    secondaryContainer: Color(0xFF2ECC71), // Verde meno fluorescente
    tertiary: Color(0xFF00BFFF), // Deep Sky Blue
    tertiaryContainer: Color(0xFF1E90FF), // Dodger Blue
    surface: Color(0xFF0A0E27), // Very dark (almost black)
    surfaceContainerHighest: Color(0xFF1A1F3A), // Dark navy
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onTertiary: Colors.white,
    onSurface: Color(0xFFE0FFFF), // Cyan white
    outline: Color(0xFF32CD32), // Lime Green outline
    outlineVariant: Color(0xFFDC143C), // Crimson outline variant
    inversePrimary: Color(0xFFDC143C),
    inverseSurface: Color(0xFFE0FFFF),
    error: Color(0xFFFF0033), // Bright Red
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF050A1A),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0A0E27),
    foregroundColor: Color(0xFF00FFFF),
    elevation: 2,
    surfaceTintColor: Color(0xFF0A0E27),
    titleTextStyle: TextStyle(
      color: Color(0xFF00FFFF),
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0A0E27),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF0A0E27),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFDC143C),
    foregroundColor: Colors.white,
    elevation: 8,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF0A0E27),
    surfaceTintColor: Color(0xFF0A0E27),
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: const Color(0xFF0A0E27),
    indicatorColor: const Color(0xFFDC143C),
    labelTextStyle: MaterialStateProperty.all(
      const TextStyle(color: Color(0xFFE0FFFF)),
    ),
    iconTheme: MaterialStateProperty.all(
      const IconThemeData(color: Color(0xFFE0FFFF)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0A0E27),
    selectedItemColor: Color(0xFFDC143C),
    unselectedItemColor: Color(0xFFE0FFFF),
    showUnselectedLabels: true,
    elevation: 6,
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF1A1F3A),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(
        color: Color(0xFFDC143C),
        width: 1.5,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1A1F3A),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color(0xFF32CD32),
        width: 2,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color(0xFF32CD32),
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color(0xFFDC143C),
        width: 2,
      ),
    ),
    prefixIconColor: const Color(0xFF00FFFF),
    suffixIconColor: const Color(0xFFDC143C),
    hintStyle: const TextStyle(
      color: Color(0xFF32CD32),
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFFDC143C),
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
    headlineMedium: TextStyle(
      color: Color(0xFF00FFFF),
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFE0FFFF),
    ),
    labelMedium: TextStyle(
      color: Color(0xFF32CD32),
      fontWeight: FontWeight.bold,
    ),
  ),
);

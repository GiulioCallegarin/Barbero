import 'package:barbero/theme/dark_mode.dart';
import 'package:barbero/theme/light_mode.dart';
import 'package:barbero/theme/experimental_mode.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  final _settings = Hive.box('settings');
  late ThemeData _themeData;

  ThemeProvider() {
    _initTheme();
  }

  void _initTheme() {
    final themeName = _settings.get('themeName', defaultValue: 'light');
    _themeData = _getThemeByName(themeName);
  }

  ThemeData _getThemeByName(String name) {
    switch (name) {
      case 'dark':
        return darkMode;
      case 'experimental':
        return experimentalMode;
      default:
        return lightMode;
    }
  }

  ThemeData get themeData => _themeData;
  
  String get currentThemeName => _settings.get('themeName', defaultValue: 'light');
  bool get isDarkMode => _themeData == darkMode;
  bool get isExperimental => _themeData == experimentalMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void setTheme(String themeName) {
    _themeData = _getThemeByName(themeName);
    _settings.put('themeName', themeName);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == darkMode) {
      setTheme('light');
    } else if (_themeData == experimentalMode) {
      setTheme('light');
    } else {
      setTheme('dark');
    }
  }
}

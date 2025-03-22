import 'package:barbero/theme/dark_mode.dart';
import 'package:barbero/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  final _settings = Hive.box('settings');
  ThemeData _themeData =
      Hive.box('settings').get('darkMode', defaultValue: false)
          ? darkMode
          : lightMode;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == darkMode) {
      themeData = lightMode;
      _settings.put('darkMode', false);
    } else {
      themeData = darkMode;
      _settings.put('darkMode', true);
    }
  }
}

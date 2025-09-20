import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class ThemeProvider with ChangeNotifier {
  // Initial theme
  ThemeData _themeData = lightThemeData;

  // Getter
  ThemeData get themeData => _themeData;

  // Setter
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // notify listeners whenever theme changes
  }

  // Toggle between light and dark
  void toggleTheme() {
    if (_themeData == lightThemeData) {
      themeData = darkThemeData;
    } else {
      themeData = lightThemeData;
    }
  }
}

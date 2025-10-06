import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  late Box<bool> isDarkThemeBox;

  ThemeProvider() {
    isDarkThemeBox = Hive.box<bool>('isDarkTheme');
    bool isDark = isDarkThemeBox.get('isDark', defaultValue: false)!;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  late ThemeMode themeMode;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  // Toggle between light and dark mode
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    isDarkThemeBox.put('isDark', isOn);
    notifyListeners();
  }
}

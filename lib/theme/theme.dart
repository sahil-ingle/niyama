import 'package:flutter/material.dart';

// ------------------
// Color Palette - Dark (Improved)
// ------------------

// Background & surfaces
final HSLColor surfaceDark = HSLColor.fromAHSL(1.0, 210, 0.20, 0.10);
final HSLColor cardSurfaceDark = HSLColor.fromAHSL(1.0, 210, 0.18, 0.18);

// Primary & Secondary
final HSLColor primaryDark = HSLColor.fromAHSL(
  1.0,
  45,
  0.95,
  0.55,
); // brighter yellow
final HSLColor secondaryDark = HSLColor.fromAHSL(
  1.0,
  160,
  0.75,
  0.50,
); // richer green

// Text
final HSLColor textPrimaryDark = HSLColor.fromAHSL(1.0, 0, 0.0, 0.97);
final HSLColor textSecondaryDark = HSLColor.fromAHSL(1.0, 0, 0.0, 0.75);

// Borders & dividers
final HSLColor borderColorDark = HSLColor.fromAHSL(1.0, 210, 0.30, 0.38);

// ------------------
// Color Palette - Light (Improved)
// ------------------

// Background & surfaces
final HSLColor surfaceLight = HSLColor.fromAHSL(1.0, 210, 0.12, 0.96);
final HSLColor cardSurfaceLight = HSLColor.fromAHSL(1.0, 210, 0.10, 0.98);

// Primary & Secondary
final HSLColor primaryLight = HSLColor.fromAHSL(1.0, 45, 0.85, 0.50);
final HSLColor secondaryLight = HSLColor.fromAHSL(1.0, 160, 0.65, 0.45);

// Text
final HSLColor textPrimaryLight = HSLColor.fromAHSL(1.0, 0, 0.0, 0.10);
final HSLColor textSecondaryLight = HSLColor.fromAHSL(1.0, 0, 0.0, 0.55);

// Borders & dividers
final HSLColor borderColorLight = HSLColor.fromAHSL(1.0, 210, 0.25, 0.85);

// ------------------
// Dark ThemeData
// ------------------
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: surfaceDark.toColor(),
  cardColor: cardSurfaceDark.toColor(),
  appBarTheme: AppBarTheme(
    backgroundColor: cardSurfaceDark.toColor(),
    foregroundColor: textPrimaryDark.toColor(),
    elevation: 2,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryDark.toColor(),
    foregroundColor: textPrimaryDark.toColor(),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark.toColor(),
    onPrimary: textPrimaryDark.toColor(),
    secondary: secondaryDark.toColor(),
    onSecondary: textPrimaryDark.toColor(),
    surface: cardSurfaceDark.toColor(),
    onSurface: textPrimaryDark.toColor(),
    error: Colors.redAccent,
    onError: Colors.white,
  ),
  dividerColor: borderColorDark.toColor(),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: textPrimaryDark.toColor()),
    bodyMedium: TextStyle(color: textSecondaryDark.toColor()),
    bodySmall: TextStyle(color: textSecondaryDark.toColor()),
    titleLarge: TextStyle(
      color: primaryDark.toColor(),
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: primaryDark.toColor(),
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(color: primaryDark.toColor()),
    labelLarge: TextStyle(color: secondaryDark.toColor()),
    labelMedium: TextStyle(color: secondaryDark.toColor()),
    labelSmall: TextStyle(color: secondaryDark.toColor()),
  ),
);

// ------------------
// Light ThemeData
// ------------------
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: surfaceLight.toColor(),
  cardColor: cardSurfaceLight.toColor(),
  appBarTheme: AppBarTheme(
    backgroundColor: cardSurfaceLight.toColor(),
    foregroundColor: textPrimaryLight.toColor(),
    elevation: 2,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryLight.toColor(),
    foregroundColor: textPrimaryLight.toColor(),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: primaryLight.toColor(),
    onPrimary: textPrimaryLight.toColor(),
    secondary: secondaryLight.toColor(),
    onSecondary: textPrimaryLight.toColor(),
    surface: cardSurfaceLight.toColor(),
    onSurface: textPrimaryLight.toColor(),
    error: Colors.redAccent,
    onError: Colors.white,
  ),
  dividerColor: borderColorLight.toColor(),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: textPrimaryLight.toColor()),
    bodyMedium: TextStyle(color: textSecondaryLight.toColor()),
    bodySmall: TextStyle(color: textSecondaryLight.toColor()),
    titleLarge: TextStyle(
      color: primaryLight.toColor(),
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: primaryLight.toColor(),
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(color: primaryLight.toColor()),
    labelLarge: TextStyle(color: secondaryLight.toColor()),
    labelMedium: TextStyle(color: secondaryLight.toColor()),
    labelSmall: TextStyle(color: secondaryLight.toColor()),
  ),
);

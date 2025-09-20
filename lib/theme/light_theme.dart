import 'package:flutter/material.dart';

/// light Color Scheme
final kColorSchemeLight = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.light, // Ensures light-appropriate colors
);

/// light Theme Data
final ThemeData lightThemeData = ThemeData.light().copyWith(
  colorScheme: kColorSchemeLight,

  // Scaffold background
  scaffoldBackgroundColor: kColorSchemeLight.surface.withValues(alpha: 0.8),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorSchemeLight.surface,
      foregroundColor: kColorSchemeLight.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: kColorSchemeLight.surfaceContainer.withValues(alpha: 0.5),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
  ),

  // AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: kColorSchemeLight.surface,
    foregroundColor: kColorSchemeLight.onSurface,
    elevation: 0,
    centerTitle: true,
  ),

  // Text Theme
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: kColorSchemeLight.onSurface,
    displayColor: kColorSchemeLight.onSurface,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: kColorSchemeLight.primary,
    foregroundColor: kColorSchemeLight.onPrimary,
  ),

  // ExpansionTile Theme
  expansionTileTheme: ExpansionTileThemeData(
    backgroundColor: kColorSchemeLight.secondaryContainer.withValues(
      alpha: 0.5,
    ), // tile background
    collapsedBackgroundColor: kColorSchemeLight.secondaryContainer.withValues(
      alpha: 0.5,
    ), // when collapsed
    textColor: kColorSchemeLight.onSecondaryContainer, // main text color
    collapsedTextColor: kColorSchemeLight.onSecondaryContainer,
    iconColor: kColorSchemeLight.primary, // expanded icon
    collapsedIconColor: kColorSchemeLight.onSecondaryContainer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
  ),
);

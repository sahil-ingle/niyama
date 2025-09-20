import 'package:flutter/material.dart';

/// Dark Color Scheme
final kColorSchemeDark = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.dark, // Ensures dark-appropriate colors
);

/// Dark Theme Data
final ThemeData darkThemeData = ThemeData.dark().copyWith(
  colorScheme: kColorSchemeDark,

  // Scaffold background
  scaffoldBackgroundColor: kColorSchemeDark.surface,

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorSchemeDark.primaryContainer,
      foregroundColor: kColorSchemeDark.onPrimaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: kColorSchemeDark.secondaryContainer.withValues(alpha: 0.5),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
  ),

  // AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: kColorSchemeDark.surface,
    foregroundColor: kColorSchemeDark.onSurface,
    elevation: 0,
    centerTitle: true,
  ),

  // Text Theme
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: kColorSchemeDark.onSurface,
    displayColor: kColorSchemeDark.onSurface,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: kColorSchemeDark.primary,
    foregroundColor: kColorSchemeDark.onPrimary,
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kColorSchemeDark.secondaryContainer.withValues(alpha: 0.5),
    unselectedItemColor: kColorSchemeDark.onSecondaryContainer,
    selectedItemColor: kColorSchemeDark.primary,
  ),

  inputDecorationTheme: InputDecorationTheme(
    fillColor: kColorSchemeDark.secondaryContainer,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kColorSchemeDark.primary, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kColorSchemeDark.error, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return kColorSchemeDark.secondary; // Selected in dark mode
        }
        return kColorSchemeDark.secondaryContainer; // Default in dark mode
      }),
      shape: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          );
        }
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(40));
      }),
    ),
  ),

  // ExpansionTile Theme
  expansionTileTheme: ExpansionTileThemeData(
    backgroundColor: kColorSchemeDark.secondaryContainer.withValues(
      alpha: 0.5,
    ), // tile background
    collapsedBackgroundColor: kColorSchemeDark.secondaryContainer.withValues(
      alpha: 0.5,
    ), // when collapsed
    textColor: kColorSchemeDark.onSecondaryContainer, // main text color
    collapsedTextColor: kColorSchemeDark.onSecondaryContainer,
    iconColor: kColorSchemeDark.primary, // expanded icon
    collapsedIconColor: kColorSchemeDark.onSecondaryContainer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
  ),
);

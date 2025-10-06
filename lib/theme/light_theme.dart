import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

final Box<int> myThemeColor = Hive.box<int>('themeColor');
final Color mySeedColor = Color(
  myThemeColor.get("color") ?? Colors.green.value,
);

/// light Color Scheme
final kColorSchemeLight = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.light, // Ensures light-appropriate colors
);

/// light Theme Data
final ThemeData lightThemeData = ThemeData.light().copyWith(
  colorScheme: kColorSchemeLight,

  // Scaffold background
  scaffoldBackgroundColor: kColorSchemeLight.secondaryContainer,

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
    color: kColorSchemeLight.surface,
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

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kColorSchemeLight.surface,
    unselectedItemColor: kColorSchemeLight.onSurface,
    selectedItemColor: kColorSchemeLight.primary,
  ),

  inputDecorationTheme: InputDecorationTheme(
    fillColor: kColorSchemeLight.surface,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kColorSchemeLight.primary, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kColorSchemeLight.error, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return kColorSchemeLight.primary; // Selected in dark mode
        }
        return kColorSchemeLight.surfaceContainer; // Default in dark mode
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

  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white),
  ),

  // ExpansionTile Theme
  // expansionTileTheme: ExpansionTileThemeData(
  //   backgroundColor: kColorSchemeLight.secondaryContainer.withValues(
  //     alpha: 0.5,
  //   ), // tile background
  //   collapsedBackgroundColor: kColorSchemeLight.secondaryContainer.withValues(
  //     alpha: 0.5,
  //   ), // when collapsed
  //   textColor: kColorSchemeLight.onSecondaryContainer, // main text color
  //   collapsedTextColor: kColorSchemeLight.onSecondaryContainer,
  //   iconColor: kColorSchemeLight.primary, // expanded icon
  //   collapsedIconColor: kColorSchemeLight.onSecondaryContainer,
  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //   childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //   tilePadding: const EdgeInsets.symmetric(horizontal: 16),
  // ),
);

import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class MyToggle extends StatefulWidget {
  const MyToggle({
    required this.selectedLabelIndex,
    required this.selectedHabitIndex,
    super.key,
  });

  final Function(int) selectedLabelIndex;
  final int selectedHabitIndex;

  @override
  State<MyToggle> createState() => _MyToggleState();
}

class _MyToggleState extends State<MyToggle> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FlutterToggleTab(
      width: 48,
      borderRadius: 16,
      height: 54,
      selectedBackgroundColors: [Theme.of(context).colorScheme.primary],
      dataTabs: [
        DataTab(title: "Positive"),
        DataTab(title: "Negative"),
      ],
      selectedTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      unSelectedBackgroundColors: [
        isDarkMode
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.surface,
      ],
      unSelectedTextStyle: TextStyle(
        color: isDarkMode
            ? Theme.of(context).colorScheme.onSecondaryContainer
            : Theme.of(context).colorScheme.onSurface,
      ),

      selectedLabelIndex: widget.selectedLabelIndex,

      selectedIndex: widget.selectedHabitIndex,
    );
  }
}

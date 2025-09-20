import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {
  const MyDropDown({required this.onChanged, super.key});

  final Function(String?)? onChanged;

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return CustomDropdown(
      hintText: "Goal",

      items: ['7 days', '21 days', "30 days", "90 days", "365 days"],
      onChanged: widget.onChanged,

      decoration: CustomDropdownDecoration(
        closedBorderRadius: BorderRadius.circular(16),
        closedFillColor: isDarkMode
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.surface,
        expandedFillColor: isDarkMode
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.surface,
        hintStyle: TextStyle(
          color: isDarkMode
              ? Theme.of(context).colorScheme.onSecondaryContainer
              : Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
        ),
        headerStyle: TextStyle(
          color: isDarkMode
              ? Theme.of(context).colorScheme.onSecondaryContainer
              : Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
        ),
        listItemStyle: TextStyle(
          color: isDarkMode
              ? Theme.of(context).colorScheme.onSecondaryContainer
              : Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
        ),
      ),
    );
  }
}

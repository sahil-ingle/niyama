import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class MyAddDateDropDown extends StatefulWidget {
  const MyAddDateDropDown({required this.onChanged, super.key});

  final Function(String?)? onChanged;
  @override
  State<MyAddDateDropDown> createState() => _MyAddDateDropDownState();
}

class _MyAddDateDropDownState extends State<MyAddDateDropDown> {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      hintText: "Extend",

      items: ['7 days', '21 days', "30 days", "90 days", "365 days"],
      onChanged: widget.onChanged,

      decoration: CustomDropdownDecoration(
        closedBorderRadius: BorderRadius.circular(16),
        closedFillColor: Theme.of(context).colorScheme.secondaryContainer,
        expandedFillColor: Theme.of(context).colorScheme.secondaryContainer,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontSize: 16,
        ),
        headerStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontSize: 16,
        ),
        listItemStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontSize: 16,
        ),
      ),
    );
  }
}

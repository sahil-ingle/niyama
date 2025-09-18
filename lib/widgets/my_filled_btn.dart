import 'package:flutter/material.dart';

class MyFilledBtn extends StatelessWidget {
  const MyFilledBtn({
    required this.onTap,
    required this.isSelected,
    required this.day,
    super.key,
  });

  final Function() onTap;
  final bool isSelected;
  final String day;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,

      style: FilledButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.surface,

        shape: RoundedRectangleBorder(
          borderRadius: isSelected
              ? BorderRadiusGeometry.circular(12)
              : BorderRadiusGeometry.circular(40),
        ),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onSecondary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

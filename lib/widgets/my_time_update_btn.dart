import 'package:flutter/material.dart';

class MyTimeUpdateBtn extends StatefulWidget {
  const MyTimeUpdateBtn({
    required this.shape,
    required this.onChanged,
    required this.icon,
    super.key,
  });

  final Function() onChanged;
  final OutlinedBorder shape;
  final IconData icon;

  @override
  State<MyTimeUpdateBtn> createState() => _MyTimeUpdateBtnState();
}

class _MyTimeUpdateBtnState extends State<MyTimeUpdateBtn> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FilledButton(
      onPressed: widget.onChanged,

      style: FilledButton.styleFrom(
        backgroundColor: isDarkMode
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.surface,
        iconColor: isDarkMode
            ? Theme.of(context).colorScheme.onSecondaryContainer
            : Theme.of(context).colorScheme.onSurface,
        elevation: 0,

        shape: widget.shape,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Icon(widget.icon),
      ),
    );
  }
}

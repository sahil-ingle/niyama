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
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
      ),
      child: Text(day),
    );
  }
}

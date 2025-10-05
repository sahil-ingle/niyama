import 'package:flutter/material.dart';

class MyElevatedBtn extends StatelessWidget {
  const MyElevatedBtn({
    this.fixedSize = const Size(160, 52),
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final Function() onTap;
  final Size fixedSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        fixedSize: fixedSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
      ),

      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}

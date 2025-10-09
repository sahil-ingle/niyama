import 'package:flutter/material.dart';

class MyToDoCard extends StatefulWidget {
  const MyToDoCard({required this.text, super.key});

  final String text;

  @override
  State<MyToDoCard> createState() => _MyToDoCardState();
}

class _MyToDoCardState extends State<MyToDoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Align(
          alignment: AlignmentGeometry.centerLeft,
          child: Text(
            widget.text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    required this.nameController,
    required this.hintText,
    super.key,
  });

  final TextEditingController nameController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: nameController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,

        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

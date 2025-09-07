import 'package:flutter/material.dart';

class MyTodoCard extends StatelessWidget {
  const MyTodoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: Center(child: Text("To-Do")),
      ),
    );
  }
}

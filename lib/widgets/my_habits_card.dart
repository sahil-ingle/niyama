import 'package:flutter/material.dart';

class MyHabitsCard extends StatefulWidget {
  const MyHabitsCard({super.key});

  @override
  State<MyHabitsCard> createState() => _MyHabitsCardState();
}

class _MyHabitsCardState extends State<MyHabitsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: Center(child: Text("Habit")),
      ),
    );
  }
}

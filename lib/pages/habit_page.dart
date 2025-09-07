import 'package:flutter/material.dart';
import 'package:niyama/widgets/my_habits_card.dart';

class HabitPage extends StatelessWidget {
  const HabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [MyHabitsCard()]);
  }
}

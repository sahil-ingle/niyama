import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:niyama/models/habit.dart';
import 'package:niyama/navigation_page.dart';
import 'package:niyama/models/boxes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  boxHabit = await Hive.openBox<Habit>('habit');

  await Hive.openBox<String>('dateBox');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationPage());
  }
}

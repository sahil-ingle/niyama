import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/models/habit.dart';
import 'package:niyama/widgets/my_habits_card.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Habits"),
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),

        ValueListenableBuilder(
          valueListenable: boxHabit.listenable(),
          builder: (context, boxHabit, widget) {
            if (boxHabit.length <= 0) {
              return SliverList.list(children: [Text("No data")]);
            } else {
              return SliverList.builder(
                itemCount: boxHabit.length,
                itemBuilder: (context, index) {
                  Habit myHabit = boxHabit.getAt(index);
                  return Dismissible(
                    key: ValueKey(myHabit),
                    onDismissed: (direction) {
                      boxHabit.deleteAt(index);
                    },
                    child: MyHabitsCard(
                      habitName: myHabit.habitName,
                      goal: myHabit.goalDays,
                      currentStreak: myHabit.currentStreak.toString(),
                      timeAllocated: myHabit.timeAllocated.hour.toString(),
                      habitDays: {},
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
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
  void initState() {
    checkDateChange();
    super.initState();
  }

  void checkDateChange() {
    Box<String> dateBox = Hive.box<String>('dateBox');
    DateTime today = DateTime.now();
    int day = today.day;

    if (dateBox.isEmpty) {
      dateBox.put('today', day.toString());
    } else if (dateBox.get('today') != day.toString()) {
      increaseStreak();
      dateBox.put('today', day.toString());
    }
  }

  void increaseStreak() {
    for (int index = 0; index < boxHabit.length; index++) {
      Habit myHabit = boxHabit.getAt(index);

      DateTime todayDate = DateTime.now();
      DateTime yesterdayDate = todayDate.subtract(Duration(days: 1));

      String yesterdaysDay = DateFormat(
        'EEE',
      ).format(yesterdayDate).toUpperCase();

      if (myHabit.isCompleted) {
        if (myHabit.currentStreak > myHabit.longestStreak) {
          myHabit.longestStreak = myHabit.currentStreak;
        }
        myHabit.isCompleted = false;
      } else {
        if (myHabit.habitDays[yesterdaysDay] == true) {
          myHabit.currentStreak = 0;
        }
      }
      myHabit.save();
    }
  }

  void increaseDayCount(int index, double time) {
    Habit myHabit = boxHabit.getAt(index);

    DateTime today = DateTime.now();
    String todayDate = DateFormat('dd-MM-yyyy').format(today);

    if (myHabit.isCompleted) {
      myHabit.streakDates[todayDate] = time;
      myHabit.currentStreak++;
    } else if (myHabit.currentStreak > 0) {
      myHabit.streakDates.remove(todayDate);
      myHabit.currentStreak--;
    }
    myHabit.save();
  }

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
              return SliverList.list(children: [Text("No Data")]);
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
                      timeAllocated: myHabit.timeAllocated,
                      habitDays: {},
                      isChecked: myHabit.isCompleted,
                      btnChecked: () {
                        setState(() {
                          myHabit.isCompleted = !myHabit.isCompleted;
                          increaseDayCount(index, 2);
                        });
                      },
                      percent: myHabit.currentStreak / myHabit.goalDays,
                      streakDates: myHabit.streakDates,
                      habitIndex: index,
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

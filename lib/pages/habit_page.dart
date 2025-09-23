import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/models/habit.dart';
import 'package:niyama/services/noti_service.dart';
import 'package:niyama/widgets/my_habits_card.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  final Map<int, Timer> _timers = {};

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

      for (int i = 0; i < boxHabit.length; i++) {
        Habit myHabit = boxHabit.getAt(i);
        myHabit.timeUtilized = 0;
        myHabit.save();
      }

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

  void increaseDayCount(int index, int time) {
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

  void _startTimer(int index) {
    Habit myHabit = boxHabit.getAt(index);
    _timers[index]?.cancel();
    _timers[index] = Timer.periodic(Duration(seconds: 1), (timer) {
      if (myHabit.timeAllocated != myHabit.timeUtilized &&
          !myHabit.isCompleted) {
        setState(() {
          myHabit.timeUtilized++;
        });
      } else {
        setState(() {
          myHabit.isCompleted = true;
          myHabit.isPaused = false;
          if (myHabit.timeAllocated == myHabit.timeUtilized) {
            increaseDayCount(index, myHabit.timeUtilized);
          }
        });

        _timers[index]?.cancel();
      }
      myHabit.save();
    });
    setState(() {
      myHabit.isPaused = false;
    });
  }

  void _pauseTimer(int index) {
    Habit myHabit = boxHabit.getAt(index);
    _timers[index]?.cancel();
    setState(() => myHabit.isPaused = true);

    myHabit.save();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          pinned: true,
          expandedHeight: 160,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Habits",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),

        ValueListenableBuilder(
          valueListenable: boxHabit.listenable(),
          builder: (context, boxHabit, widget) {
            if (boxHabit.length <= 0) {
              return SliverList.list(
                children: [Center(child: Text("No Habits"))],
              );
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
                      isPositive: myHabit.isPositive,
                      habitDays: myHabit.habitDays,
                      isChecked: myHabit.isCompleted,
                      btnChecked: () {
                        setState(() {
                          myHabit.isCompleted = !myHabit.isCompleted;
                          increaseDayCount(index, myHabit.timeUtilized);
                        });
                      },
                      percent: myHabit.currentStreak / myHabit.goalDays,
                      streakDates: myHabit.streakDates,

                      isPaused: myHabit.isPaused,
                      dislayTime: myHabit.timeAllocated - myHabit.timeUtilized,

                      btnPlayPause: () {
                        setState(() {
                          if (!myHabit.isCompleted) {
                            if (!myHabit.isPaused) {
                              _startTimer(index);
                              NotiService().showNotification(
                                title: "Timer Started",
                                body: myHabit.habitName,
                              );
                            } else {
                              _pauseTimer(index);
                            }
                            myHabit.isPaused = !myHabit.isPaused;
                          }
                        });
                      },
                      myHabit: myHabit,
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

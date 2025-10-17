import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/models/habit.dart';
import 'package:niyama/pages/habit_edit_page.dart';
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

    if (myHabit.isCompleted) return;

    // Cancel existing notification
    NotiService().cancelNotification(index + 28);

    // Set lastStartTime if starting fresh or resuming
    myHabit.lastStartTime ??= DateTime.now().millisecondsSinceEpoch;
    myHabit.isPaused = false;
    myHabit.save();

    _timers[index]?.cancel();

    _timers[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Increment time by 1 second per tick
      myHabit.timeUtilized += 1;

      if (myHabit.timeUtilized >= myHabit.timeAllocated) {
        myHabit.timeUtilized = myHabit.timeAllocated;
        myHabit.isCompleted = true;
        myHabit.isPaused = false;
        myHabit.lastStartTime = null;
        myHabit.save();

        increaseDayCount(index, myHabit.timeUtilized);

        // Cancel timer + notification
        _timers[index]?.cancel();
        NotiService().cancelNotification(index + 28);

        setState(() {});
      } else {
        myHabit.save();
        setState(() {});
      }
    });

    // Schedule completion notification
    final remainingSeconds = myHabit.timeAllocated - myHabit.timeUtilized;
    NotiService().scheduleNotification(
      id: index + 28,
      title: 'Habit "${myHabit.habitName}" Completed!',
      body: 'You have successfully reached your habit goal time.',
      duration: Duration(seconds: remainingSeconds),
    );
  }

  void _pauseTimer(int index) {
    Habit myHabit = boxHabit.getAt(index);

    _timers[index]?.cancel();
    myHabit.isPaused = true;
    myHabit.lastStartTime = null;
    myHabit.save();

    NotiService().cancelNotification(index + 28);

    setState(() {});
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
              return SliverFillRemaining(
                child: Center(child: Text("No Habits")),
              );
            } else {
              final String today = DateFormat(
                'EEE',
              ).format(DateTime.now()).toUpperCase();

              List<int> sortedIndexes = List.generate(
                boxHabit.length,
                (i) => i,
              );

              sortedIndexes.sort((a, b) {
                final Habit habitA = boxHabit.getAt(a)!;
                final Habit habitB = boxHabit.getAt(b)!;

                final bool aToday = habitA.habitDays[today] ?? false;
                final bool bToday = habitB.habitDays[today] ?? false;

                // Habits active today come first
                if (aToday && !bToday) return -1;
                if (!aToday && bToday) return 1;
                return 0; // keep original order if both same
              });

              return SliverList.builder(
                itemCount: boxHabit.length,
                itemBuilder: (context, index) {
                  final int hiveIndex = sortedIndexes[index];
                  final Habit myHabit = boxHabit.getAt(hiveIndex)!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Slidable(
                      key: ValueKey(myHabit),

                      startActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(16),
                            onPressed: (key) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HabitEditPage(index: hiveIndex),
                                ),
                              );
                            },
                            icon: FontAwesome.pen_to_square_solid,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.9),
                          ),
                        ],
                      ),

                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(16),
                            onPressed: (key) {
                              boxHabit.deleteAt(hiveIndex);
                              NotiService().cancelAllHabitNotifications(
                                myHabit.habitName,
                              );
                            },
                            icon: FontAwesome.trash_can_solid,
                            backgroundColor: Colors.redAccent,
                          ),
                        ],
                      ),

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
                            increaseDayCount(hiveIndex, myHabit.timeUtilized);
                          });
                        },
                        percent: myHabit.currentStreak / myHabit.goalDays,
                        streakDates: myHabit.streakDates,

                        isPaused: myHabit.isPaused,
                        dislayTime:
                            myHabit.timeAllocated - myHabit.timeUtilized,

                        btnPlayPause: () {
                          setState(() {
                            if (!myHabit.isCompleted) {
                              if (!myHabit.isPaused) {
                                _startTimer(hiveIndex);
                                NotiService().showNotification(
                                  title: "Timer Started",
                                  body: myHabit.habitName,
                                );
                              } else {
                                _pauseTimer(hiveIndex);
                              }
                              myHabit.isPaused = !myHabit.isPaused;
                            }
                          });
                        },
                        myHabit: myHabit,
                      ),
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

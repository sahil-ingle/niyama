import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/models/habit.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:table_calendar/table_calendar.dart';

class MyHabitsCard extends StatefulWidget {
  const MyHabitsCard({
    required this.habitName,
    required this.goal,
    required this.currentStreak,
    required this.timeAllocated,
    required this.habitDays,
    required this.isChecked,
    required this.btnChecked,
    required this.percent,
    required this.streakDates,
    required this.habitIndex,
    super.key,
  });

  final String habitName;
  final int goal;
  final String currentStreak;
  final int timeAllocated;
  final Map<String, bool> habitDays;
  final bool isChecked;
  final double percent;
  final Map<String, int> streakDates;
  final int habitIndex;

  final Function() btnChecked;

  @override
  State<MyHabitsCard> createState() => _MyHabitsCardState();
}

class _MyHabitsCardState extends State<MyHabitsCard> {
  late int _seconds;
  bool _isPaused = false;
  Timer? _timer;
  late Habit myHabit;
  late int _timeUtilized;

  @override
  void initState() {
    super.initState();
    myHabit = boxHabit.getAt(widget.habitIndex);
    _seconds = widget.timeAllocated;
    _timeUtilized = myHabit.timeUtilized;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
          _timeUtilized++;
        });
      } else {
        myHabit.isCompleted = true;
        _timer?.cancel();
      }
      myHabit.timeUtilized = _timeUtilized;
      myHabit.timeAllocated = _seconds;
      myHabit.save();
    });
    setState(() {
      _isPaused = false;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isPaused = true);
    myHabit.timeUtilized = _timeUtilized;
    myHabit.timeAllocated = _seconds;
    myHabit.save();
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Theme.of(context).colorScheme.surface,

      child: ExpansionTile(
        showTrailingIcon: false,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: widget.btnChecked,

                  child: Icon(
                    widget.isChecked
                        ? FontAwesome.circle_check_solid
                        : FontAwesome.circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 26,
                  ),
                ),

                SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habitName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      "Goal - ${widget.goal} Days",
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
                Spacer(),

                Text(
                  _formatTime(_seconds),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                SizedBox(width: 8),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!_isPaused) {
                        _startTimer();
                      } else {
                        _pauseTimer();
                      }
                      _isPaused = !_isPaused;
                    });
                  },
                  child: Icon(
                    _isPaused
                        ? FontAwesome.circle_pause_solid
                        : FontAwesome.circle_play_solid,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  FontAwesome.fire_solid,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "${widget.currentStreak} Days",
                  style: TextStyle(fontSize: 15),
                ),
                Spacer(),
                GestureDetector(
                  child: Icon(
                    FontAwesome.chart_simple_solid,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 22,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            LinearPercentIndicator(
              barRadius: Radius.circular(16),
              lineHeight: 12,
              percent: widget.percent,
              padding: EdgeInsets.all(0),
              progressColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ],
        ),

        children: [
          TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: CalendarFormat.week,
            headerVisible: false,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),

            // highlight if the day exists in streakDates
            selectedDayPredicate: (day) {
              final dateKey = DateFormat('dd-MM-yyyy').format(day);
              return widget.streakDates.containsKey(dateKey);
            },

            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

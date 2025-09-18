import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/models/habit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  int getTotalCompletedHabit() {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    int completedHabit = 0;

    for (int i = 0; i < now.day; i++) {
      DateTime currentDay = startOfMonth.add(Duration(days: i));
      String formattedTime = DateFormat('dd-MM-yyyy').format(currentDay);

      for (int j = 0; j < boxHabit.length; j++) {
        Habit myHabit = boxHabit.getAt(j);
        if (myHabit.streakDates.containsKey(formattedTime)) {
          completedHabit++;
        }
      }
    }
    return completedHabit;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final int totalDaysinMonth = DateTime(now.year, now.month + 1, 0).day;
    final double monthCompleted = now.day / totalDaysinMonth;
    final int totalHabits = boxHabit.length * now.day;
    final int completedHabit = getTotalCompletedHabit();
    final double successRate = totalHabits == 0
        ? 0
        : completedHabit / totalHabits;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("Hello, Sahil"),
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),
        SliverList.list(
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Monthly Overview",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${(successRate * 100).toStringAsFixed(0)}%",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Habit Success Rate",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 8.0,
                      percent: monthCompleted,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${(monthCompleted * 100).toStringAsFixed(0)}%",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "Month\nCompleted",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      progressColor: Colors.green,
                      backgroundColor: Colors.grey[200]!,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1200,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

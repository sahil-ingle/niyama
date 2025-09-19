import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/models/habit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  int getToatalCompleted() {
    int completedHabit = 0;

    for (int i = 0; i < boxHabit.length; i++) {
      Habit myHabit = boxHabit.getAt(i);
      if (myHabit.isCompleted) {
        completedHabit++;
      }
    }

    return completedHabit;
  }

  int gettotalTimeUtilizedPercent() {
    int totalTimeAllocated = 0;
    int totalTimeUtilized = 0;

    for (int i = 0; i < boxHabit.length; i++) {
      Habit myHabit = boxHabit.getAt(i);
      totalTimeAllocated += myHabit.timeAllocated;
      totalTimeUtilized += myHabit.timeUtilized;
    }

    if (totalTimeAllocated == 0) return 0;

    return ((totalTimeUtilized / totalTimeAllocated) * 100).truncate();
  }

  @override
  Widget build(BuildContext context) {
    final int completedHabit = getToatalCompleted();
    final int totalHabit = boxHabit.length;

    final int totalTimeUtilizedPercent = gettotalTimeUtilizedPercent();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Hello, Sahil",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
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
                          "Daily Overview",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "$totalTimeUtilizedPercent%",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Today's Success Rate",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 8.0,
                      percent: totalHabit == 0
                          ? 0.0
                          : completedHabit / totalHabit,

                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$completedHabit / $totalHabit",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      progressColor: Theme.of(context).colorScheme.secondary,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onSecondary,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1200,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Heat Map",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 8),

            HeatMap(
              colorsets: {
                1: Theme.of(context).colorScheme.primary,
                2: Colors.black,
                3: Colors.blue,
                4: Colors.red,
              },

              datasets: {DateTime(2025, 09, 15): 1},
              showColorTip: false,
              scrollable: true,
              startDate: DateTime.now().subtract(Duration(days: 85)),
              colorMode: ColorMode.color,
            ),
            SizedBox(height: 8),
          ],
        ),
      ],
    );
  }
}

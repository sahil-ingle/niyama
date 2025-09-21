import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/models/habit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Box<String> myProfile = Hive.box<String>('profile');

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

  int getTotalHabit() {
    int totalHabit = 0;

    DateTime now = DateTime.now();

    String todayDay = DateFormat('EEE').format(now).toUpperCase();

    for (int i = 0; i < boxHabit.length; i++) {
      Habit myHabit = boxHabit.getAt(i);
      if (myHabit.habitDays[todayDay] == true) {
        totalHabit++;
      }
    }

    return totalHabit;
  }

  int gettotalTimeUtilizedPercent() {
    int totalTimeAllocated = 0;
    int totalTimeUtilized = 0;

    DateTime now = DateTime.now();

    String todayDay = DateFormat('EEE').format(now).toUpperCase();

    for (int i = 0; i < boxHabit.length; i++) {
      Habit myHabit = boxHabit.getAt(i);

      if (myHabit.habitDays[todayDay] == true) {
        totalTimeAllocated += myHabit.timeAllocated;
      }
      totalTimeUtilized += myHabit.timeUtilized;
    }

    if (totalTimeAllocated == 0) return 0;

    return ((totalTimeUtilized / totalTimeAllocated) * 100).truncate();
  }

  Map<DateTime, int> getHeatMapData() {
    final Map<DateTime, int> heatmap = {};
    final List<Habit> habits = [
      for (int i = 0; i < boxHabit.length; i++) boxHabit.getAt(i),
    ];

    DateTime currentDate = DateTime.now().subtract(const Duration(days: 69));

    for (int i = 0; i < 70; i++) {
      final dateKey = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );
      final dateString =
          '${currentDate.day.toString().padLeft(2, '0')}-'
          '${currentDate.month.toString().padLeft(2, '0')}-'
          '${currentDate.year}';

      for (final habit in habits) {
        // Skip if current date is before the habit started
        if (currentDate.isBefore(habit.startDate)) continue;

        final currentCount = heatmap[dateKey] ?? 0;

        if (habit.streakDates.containsKey(dateString) && habit.isPositive) {
          // Positive habit completed
          if (currentCount < 4) {
            heatmap[dateKey] = currentCount + 1;
          }
        } else if (!habit.streakDates.containsKey(dateString) &&
            !habit.isPositive) {
          // Negative habit missed
          final count = currentCount < 4
              ? 5
              : (currentCount < 9 ? currentCount + 1 : currentCount);
          heatmap[dateKey] = count;
        }
      }

      // Move to the next day
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return heatmap;
  }

  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final int completedHabit = getToatalCompleted();
    final int totalHabit = getTotalHabit();

    final int totalTimeUtilizedPercent = gettotalTimeUtilizedPercent();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          flexibleSpace: FlexibleSpaceBar(
            title: ValueListenableBuilder(
              valueListenable: myProfile.listenable(),
              builder: (context, box, _) {
                final name = box.get("name") != null
                    ? "Hey, ${box.get('name')}"
                    : "Welcome";
                return Text(
                  name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),
        SliverList.list(
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondaryContainer,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "$totalTimeUtilizedPercent%",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: totalTimeUtilizedPercent > 100
                                ? Colors.amberAccent
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Today's Success Rate",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer
                                .withValues(alpha: 0.5),
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
                          : (completedHabit / totalHabit).clamp(0.0, 1.0),

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
                      progressColor: totalTimeUtilizedPercent > 100
                          ? Colors.amberAccent
                          : Theme.of(context).colorScheme.secondary,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onSecondaryContainer.withValues(alpha: 0.1),

                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1200,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 16,
                top: 4,
                bottom: 8,
              ),
              child: Text(
                "Heat Map",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 16),

              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 20,
                  left: 16,
                  right: 16,
                ),
                child: HeatMap(
                  size: 20,
                  colorsets: {
                    1: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    2: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                    3: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.7),
                    4: Theme.of(context).colorScheme.primary,

                    5: Colors.red.withValues(alpha: 0.2),
                    6: Colors.red.withValues(alpha: 0.4),
                    7: Colors.red.withValues(alpha: 0.6),
                    8: Colors.red.withValues(alpha: 0.8),
                    9: Colors.red,
                  },

                  defaultColor: Theme.of(
                    context,
                  ).colorScheme.onSecondaryContainer.withValues(alpha: 0.1),

                  datasets: getHeatMapData(),
                  showColorTip: false,
                  scrollable: true,
                  colorTipSize: 8,
                  textColor: Theme.of(
                    context,
                  ).colorScheme.onSecondaryContainer.withValues(alpha: 0.5),
                  startDate: DateTime.now().subtract(Duration(days: 70)),
                  colorMode: ColorMode.color,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ],
    );
  }
}

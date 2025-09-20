import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:hive/hive.dart';
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

  Map<DateTime, int> getHeatMapData() {
    Map<DateTime, int> heatmap = {};
    DateTime currentDate = DateTime.now().subtract(const Duration(days: 69));
    int habitCount = boxHabit.length;

    for (int i = 0; i < 70; i++) {
      final formattedDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );
      final dateString = DateFormat('dd-MM-yyyy').format(currentDate);

      for (int j = 0; j < habitCount; j++) {
        final Habit myHabit = boxHabit.getAt(j);

        if (myHabit.streakDates.containsKey(dateString)) {
          // Increment count for this date
          int currentCount = heatmap[formattedDate] ?? 0;

          // Only increment if less than or equal to 4
          if (currentCount < 5) {
            heatmap[formattedDate] = currentCount + 1;
          }
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
    final int totalHabit = boxHabit.length;

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
                            color: Theme.of(context).colorScheme.primary,
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
                      ).colorScheme.onSecondaryContainer.withValues(alpha: 0.1),

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

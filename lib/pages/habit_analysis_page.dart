import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:niyama/models/habit.dart';

class HabitAnalysisPage extends StatefulWidget {
  const HabitAnalysisPage({required this.myHabit, super.key});

  final Habit myHabit;

  @override
  State<HabitAnalysisPage> createState() => _HabitAnalysisPageState();
}

class _HabitAnalysisPageState extends State<HabitAnalysisPage> {
  Map<DateTime, int> getHeatMapData() {
    final Map<DateTime, int> heatmap = {};
    DateTime startDate =
        widget.myHabit.startDate.isAfter(
          DateTime.now().subtract(Duration(days: 69)),
        )
        ? widget.myHabit.startDate
        : DateTime.now().subtract(Duration(days: 69));

    DateTime currentDate = startDate;

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

      if (widget.myHabit.isPositive) {
        if (widget.myHabit.streakDates.containsKey(dateString)) {
          heatmap[dateKey] = 1;
        }
      } else {
        if (widget.myHabit.streakDates.containsKey(dateString)) {
          heatmap[dateKey] = 1;
        } else {
          heatmap[dateKey] = 2;
        }
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return heatmap;
  }

  int getTotalTimeUtilized() {
    int totalCompletedSecond = 0;
    List<int> values = widget.myHabit.streakDates.values.toList();
    for (int value in values) {
      totalCompletedSecond += value;
    }

    return (totalCompletedSecond / 60).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.myHabit.habitName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          SliverList.list(
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 16.0,
              //     vertical: 8.0,
              //   ),
              //   child: Text(
              //     "Heat Map",
              //     style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //       color: Theme.of(context).colorScheme.onSurface,
              //     ),
              //   ),
              // ),
              SizedBox(height: 16),

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
                      1: Theme.of(context).colorScheme.primary,
                      2: const Color.fromARGB(255, 251, 53, 39),
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

              // Inside your Row:
              Row(
                children: [
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Streak',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  FontAwesome
                                      .fire_flame_simple_solid, // Fire icon for current streak
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  widget.myHabit.currentStreak.toString(),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Longest Streak',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  FontAwesome
                                      .fire_solid, // Fire icon for longest streak
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  widget.myHabit.longestStreak.toString(),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Card(
                  margin: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Minute Completed',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer
                                .withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              FontAwesome
                                  .hourglass_half_solid, // Fire icon for current streak
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${getTotalTimeUtilized().toString()} Minutes',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

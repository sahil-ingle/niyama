import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:niyama/models/habit.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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

  // Convert "dd-MM-yyyy" to "dd-MM"
  String formatDate(String dateStr) {
    final parts = dateStr.split('-'); // ["25", "10", "2025"]
    return "${parts[0]}-${parts[1]}";
  }

  // Convert seconds to minutes
  double secondsToMinutes(double seconds) {
    return seconds / 60;
  }

  @override
  Widget build(BuildContext context) {
    // Get the keys and values as lists
    final allDates = widget.myHabit.streakDates.keys.toList();
    final allValues = widget.myHabit.streakDates.values.toList();

    // Take the latest 5 entries
    final latestDates = allDates.length > 5
        ? allDates.sublist(allDates.length - 5)
        : allDates;

    final latestValues = allValues.length > 5
        ? allValues.sublist(allValues.length - 5)
        : allValues;

    final double percent =
        widget.myHabit.currentStreak / widget.myHabit.goalDays;

    // Convert them to desired formats
    final List<String> dates = latestDates.map(formatDate).toList();
    final List<double> timeUtilized = latestValues
        .map((s) => secondsToMinutes(s.toDouble()))
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
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
              Card(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                        'Progress Over Goal',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.myHabit.currentStreak} / ${widget.myHabit.goalDays} days',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 8),

                          LinearPercentIndicator(
                            barRadius: const Radius.circular(16),
                            lineHeight: 12,
                            animation: true,
                            animationDuration: 400,
                            animateFromLastPercent: true,
                            percent: percent,
                            padding: EdgeInsets.zero,
                            progressColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withValues(alpha: 0.1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8),

              Card(
                elevation: 4,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),

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

              Visibility(
                visible: widget.myHabit.isPositive,
                child: Card(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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

              SizedBox(
                height: 250,
                child: Card(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                      left: 16,
                      right: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            "Weekly Chart",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ),

                        Expanded(
                          child: BarChart(
                            BarChartData(
                              minY: 0,

                              gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                              ),
                              borderData: FlBorderData(show: false),
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                        return BarTooltipItem(
                                          '${dates[groupIndex]}\n${rod.toY.toStringAsFixed(1)} mins',
                                          const TextStyle(color: Colors.black),
                                        );
                                      },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index < 0 || index >= dates.length) {
                                        return const SizedBox();
                                      }
                                      return Text(
                                        dates[index],
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    },
                                    reservedSize: 32,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 5,
                                    getTitlesWidget: (value, meta) => Text(
                                      '${value.toInt()}m',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    reservedSize: 40,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              barGroups: List.generate(timeUtilized.length, (
                                index,
                              ) {
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: timeUtilized[index],
                                      width: 20,
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary
                                              .withValues(alpha: 0.7),
                                          Theme.of(context).colorScheme.primary,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

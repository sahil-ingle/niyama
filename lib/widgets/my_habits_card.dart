import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    required this.btnPlayPause,
    required this.dislayTime,
    required this.isPaused,
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

  final int dislayTime;
  final bool isPaused;

  final Function() btnChecked;
  final Function() btnPlayPause;

  @override
  State<MyHabitsCard> createState() => _MyHabitsCardState();
}

class _MyHabitsCardState extends State<MyHabitsCard> {
  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: colorScheme.surface, // subtle card background

      child: ExpansionTile(
        showTrailingIcon: false,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),

        /// --- HEADER SECTION ---
        title: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Checkbox for habit completion
                GestureDetector(
                  onTap: widget.btnChecked,
                  child: Icon(
                    widget.isChecked
                        ? FontAwesome.circle_check_solid
                        : FontAwesome.circle,
                    color: widget.isChecked
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 12),

                /// Habit Name & Goal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habitName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      "Goal - ${widget.goal} Days",
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSecondaryContainer.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                /// Timer Display
                Text(
                  _formatTime(widget.dislayTime),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(width: 8),

                /// Play / Pause Button
                GestureDetector(
                  onTap: widget.btnPlayPause,
                  child: Icon(
                    widget.isPaused
                        ? FontAwesome.circle_pause_solid
                        : FontAwesome.circle_play_solid,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Streak and Stats Icon
            Row(
              children: [
                Icon(
                  FontAwesome.fire_solid,
                  color:
                      colorScheme.secondary, // fire color matches error color
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "${widget.currentStreak} Days",
                  style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
                ),
                const Spacer(),
                GestureDetector(
                  child: Icon(
                    FontAwesome.chart_simple_solid,
                    color: colorScheme.secondary,
                    size: 22,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Progress Bar
            LinearPercentIndicator(
              barRadius: const Radius.circular(16),
              lineHeight: 12,
              percent: widget.percent,
              padding: EdgeInsets.zero,
              progressColor: colorScheme.secondary,
              backgroundColor: colorScheme.onSecondaryContainer.withValues(
                alpha: 0.1,
              ),
            ),
          ],
        ),

        /// --- EXPANDED SECTION ---
        children: [
          TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: CalendarFormat.week,
            headerVisible: false,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),

            /// Highlight streak days
            selectedDayPredicate: (day) {
              final dateKey = DateFormat('dd-MM-yyyy').format(day);
              return widget.streakDates.containsKey(dateKey);
            },

            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: colorScheme.onSecondaryContainer),
            ),

            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),

              todayDecoration: BoxDecoration(
                color: colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(color: colorScheme.onSecondary),
              selectedTextStyle: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              defaultTextStyle: TextStyle(
                color: colorScheme.onSecondaryContainer,
              ),

              weekendTextStyle: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

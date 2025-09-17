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
    super.key,
  });

  final String habitName;
  final int goal;
  final String currentStreak;
  final DateTime timeAllocated;
  final Map<String, bool> habitDays;
  final bool isChecked;
  final double percent;
  final Map<String, double> streakDates;

  final Function() btnChecked;

  @override
  State<MyHabitsCard> createState() => _MyHabitsCardState();
}

class _MyHabitsCardState extends State<MyHabitsCard> {
  bool isPlaying = false;
  late List<DateTime> dates;

  final ScrollController _scrollController = ScrollController();

  // Define item width (must include margin/padding if you use them)
  final double itemWidth = 116; // 100 width + 16 margin (8 left + 8 right)

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      int targetIndex = 15;

      double screenWidth = MediaQuery.of(context).size.width;
      double offset =
          (itemWidth * targetIndex) - (screenWidth / 2) + (itemWidth / 2);

      if (offset < 0) offset = 0;

      _scrollController.jumpTo(offset);
    });
  }

  List<DateTime> datesGenerator() {
    List<DateTime> dates = [];

    DateTime start = DateTime.now().subtract(Duration(days: 30));

    for (int i = 0; i < 60; i++) {
      dates.add(start);
      start = start.add(Duration(days: 1));
    }

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    dates = datesGenerator();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,

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
                    color: Colors.green,
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
                      ),
                    ),
                    Text(
                      "Goal - ${widget.goal} Days",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Spacer(),

                Text(
                  "${widget.timeAllocated.hour} Hr ${widget.timeAllocated.minute} Min",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),

                SizedBox(width: 8),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  child: Icon(
                    isPlaying
                        ? FontAwesome.circle_pause
                        : FontAwesome.circle_play,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            Row(
              children: [
                Icon(FontAwesome.fire_solid, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  "${widget.currentStreak} Days",
                  style: TextStyle(fontSize: 15),
                ),
                Spacer(),
                GestureDetector(
                  child: Icon(
                    FontAwesome.chart_simple_solid,
                    color: Colors.blue,
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
              progressColor: Colors.blueAccent,
              backgroundColor: Colors.grey[300],
            ),
          ],
        ),

        children: [
          TableCalendar(
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
                color: Colors.blue,
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

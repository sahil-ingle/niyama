import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:icons_plus/icons_plus.dart';

class MyHabitsCard extends StatefulWidget {
  const MyHabitsCard({
    required this.habitName,
    required this.goal,
    required this.currentStreak,
    required this.timeAllocated,
    required this.habitDays,
    super.key,
  });

  final String habitName;
  final String goal;
  final String currentStreak;
  final String timeAllocated;
  final Map<String, bool> habitDays;

  @override
  State<MyHabitsCard> createState() => _MyHabitsCardState();
}

class _MyHabitsCardState extends State<MyHabitsCard> {
  final List<String> dates = ["1", "2", "3", "4", "5", "6", "7", "8"];
  bool isChecked = false;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
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

        title: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isChecked = !isChecked;
                    });
                  },

                  child: Icon(
                    isChecked
                        ? FontAwesome.circle_check_solid
                        : FontAwesome.circle,
                    color: Colors.green,
                    size: 28,
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
                      "Goal - ${widget.goal}",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Spacer(),

                Text(
                  "${widget.timeAllocated} hour",
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
              percent: 0.5,
              padding: EdgeInsets.all(0),
              progressColor: Colors.blueAccent,
              backgroundColor: Colors.grey[300],
            ),
          ],
        ),

        children: [
          SizedBox(
            height: 62,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.greenAccent,
                    ),
                    child: Column(children: [Text(dates[index]), Text("THU")]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

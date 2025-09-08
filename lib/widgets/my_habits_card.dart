import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyHabitsCard extends StatefulWidget {
  const MyHabitsCard({super.key});

  @override
  State<MyHabitsCard> createState() => _MyHabitsCardState();
}

class _MyHabitsCardState extends State<MyHabitsCard> {
  final List<String> dates = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "10",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ExpansionTile(
          showTrailingIcon: false,
          tilePadding: EdgeInsets.all(0),
          collapsedShape: Border(),
          shape: Border(),
          title: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 32,
                    width: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 24,
                      color: Colors.black,
                      onPressed: () {},
                      icon: Icon(Icons.circle_outlined),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Work Out",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Text("Goal - 2hr"),
                  Spacer(),
                  SizedBox(
                    height: 32,
                    width: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 32,
                      color: Colors.black,
                      onPressed: () {},
                      icon: Icon(Icons.play_arrow_rounded),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('🔥', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text("7 Days", style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text(
                    "30 min Time Left",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8),

              LinearPercentIndicator(
                percent: 0.5,
                progressColor: Colors.blueAccent,
                barRadius: Radius.circular(25),
                padding: EdgeInsets.symmetric(horizontal: 0),
                lineHeight: 8,
              ),
            ],
          ),

          children: [
            SizedBox(height: 8),
            SizedBox(
              height: 28,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.greenAccent,
                    ),
                    child: Text(dates[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

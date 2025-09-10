import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:niyama/models/habit.dart';
import 'package:niyama/widgets/my_filled_btn.dart';
import 'package:niyama/widgets/my_text_field.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import 'package:niyama/models/boxes.dart';

class HabitAddSheet extends StatefulWidget {
  const HabitAddSheet({super.key});

  @override
  State<HabitAddSheet> createState() => _HabitAddSheetState();
}

class _HabitAddSheetState extends State<HabitAddSheet> {
  final _habitNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _timePicked = DateTime(0, 0, 0, 0);
  String _selectedGoal = "";
  int _selectedHabitIndex = 0;
  bool isPositive = true;

  final Map<String, bool> _selectedDaysMap = {
    "MON": false,
    "TUE": false,
    "WED": false,
    "THU": false,
    "FRI": false,
    "SAT": false,
    "SUN": false,
  };

  void onFilledBtnTap(String day) {
    setState(() {
      _selectedDaysMap[day] = !_selectedDaysMap[day]!;
    });
  }

  void addDataHive() {
    if (_habitNameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedGoal.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Please enter all the data"),
          content: Text("put all the data"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        ),
      );
    } else {
      boxHabit.put(
        'key_${_habitNameController.text}',
        Habit(
          habitName: _habitNameController.text,
          description: _descriptionController.text,
          goalDays: _selectedGoal,
          reminderTime: DateTime.now(),
          habitDays: _selectedDaysMap,
          timeAllocated: _timePicked,
          timeUtilized: DateTime.now(),
          currentStreak: 0,
          longestStreak: 0,
          streakDates: {},
          isPositive: isPositive,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _habitNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Add New Habit",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        SizedBox(height: 40),

        MyTextField(
          nameController: _habitNameController,
          hintText: "Habit Title",
        ),
        SizedBox(height: 12),

        MyTextField(
          nameController: _descriptionController,
          hintText: "Description",
        ),
        SizedBox(height: 12),

        Row(
          children: [
            SizedBox(
              height: 60,
              width: 124,
              child: Center(
                child: CustomDropdown(
                  hintText: "Goal",
                  items: [
                    '7 days',
                    '21 days',
                    "30 days",
                    "90 days",
                    "365 days",
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGoal = value!; // addd condition here
                    });
                  },
                  decoration: CustomDropdownDecoration(
                    closedBorderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            Spacer(),

            Center(
              child: FlutterToggleTab(
                width: 48,
                borderRadius: 16,
                height: 54,
                selectedBackgroundColors: [Colors.amber],
                dataTabs: [
                  DataTab(title: "Positive"),
                  DataTab(title: "Negative"),
                ],
                selectedLabelIndex: (index) {
                  setState(() {
                    _selectedHabitIndex = index;
                    isPositive = index == 0 ? true : false;
                  });
                },
                selectedIndex: _selectedHabitIndex,
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton(
              onPressed: () {
                setState(() {
                  _timePicked = _timePicked.subtract(Duration(minutes: 15));
                });
              },

              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                iconColor: Colors.black,
                elevation: 1,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Icon(Icons.remove),
              ),
            ),

            Expanded(
              child: TimePickerSpinnerPopUp(
                initTime: _timePicked,
                minTime: DateTime(0, 0, 0, 0, 15),
                mode: CupertinoDatePickerMode.time,

                onChange: (dateTime) {
                  setState(() {
                    _timePicked = dateTime;
                  });
                },

                timeWidgetBuilder: (dateTime) {
                  return SizedBox(
                    height: 60,
                    child: Card(
                      color: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${_timePicked.hour.toString()} Hr ${_timePicked.minute.toString()} Min',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            FilledButton(
              onPressed: () {
                setState(() {
                  _timePicked = _timePicked.add(Duration(minutes: 15));
                });
              },

              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                iconColor: Colors.black,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyFilledBtn(
              onTap: () => onFilledBtnTap("MON"),
              isSelected: _selectedDaysMap["MON"]!,
              day: "MON",
            ),
            SizedBox(width: 2),

            MyFilledBtn(
              onTap: () => onFilledBtnTap("TUE"),
              isSelected: _selectedDaysMap["TUE"]!,
              day: "TUE",
            ),
            SizedBox(width: 2),
            MyFilledBtn(
              onTap: () => onFilledBtnTap("WED"),
              isSelected: _selectedDaysMap["WED"]!,
              day: "WED",
            ),
            SizedBox(width: 2),
            MyFilledBtn(
              onTap: () => onFilledBtnTap("THU"),
              isSelected: _selectedDaysMap["THU"]!,
              day: "THU",
            ),

            SizedBox(height: 20),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyFilledBtn(
              onTap: () => onFilledBtnTap("FRI"),
              isSelected: _selectedDaysMap["FRI"]!,
              day: "FRI",
            ),
            SizedBox(width: 4),
            MyFilledBtn(
              onTap: () => onFilledBtnTap("SAT"),
              isSelected: _selectedDaysMap["SAT"]!,
              day: "SAT",
            ),
            SizedBox(width: 4),
            MyFilledBtn(
              onTap: () => onFilledBtnTap("SUN"),
              isSelected: _selectedDaysMap["SUN"]!,
              day: "SUN",
            ),
          ],
        ),
        SizedBox(height: 28),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            fixedSize: Size(160, 52),
          ),
          onPressed: addDataHive,
          child: Text("Add Habit"),
        ),
      ],
    );
  }
}

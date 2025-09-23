import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:niyama/models/habit.dart';
import 'package:niyama/services/noti_service.dart';
import 'package:niyama/widgets/my_drop_down.dart';
import 'package:niyama/widgets/my_filled_btn.dart';
import 'package:niyama/widgets/my_text_field.dart';
import 'package:niyama/widgets/my_toggle.dart';
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
  int _selectedGoal = 0;
  int _selectedHabitIndex = 0;
  bool isPositive = true;

  Time _remidnerTime = Time(
    hour: DateTime.now().hour,
    minute: DateTime.now().minute,
  );

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period.name.toUpperCase();
    return "$hour:$minute $period";
  }

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

  DateTime convertTimetoDateTime(Time time) {
    DateTime now = DateTime.now();

    DateTime convertedTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    return convertedTime;
  }

  int generateHabitIdFromName(String name) {
    return name.codeUnits.fold(0, (prev, char) => prev + char);
  }

  int generateNotificationId(String habitName, int weekdayIndex) {
    int habitBaseId = generateHabitIdFromName(habitName);
    return (habitBaseId * 10) + weekdayIndex; // Combine habit and day
  }

  void addReminder() {
    final List<String> days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    for (int i = 0; i < 7; i++) {
      if (_selectedDaysMap[days[i]] == true) {
        final int uniqueId = generateNotificationId(
          _habitNameController.text,
          i,
        );
        NotiService().scheduleReminder(
          title: _habitNameController.text,
          body: 'Don\'t Procrastinate',
          id: uniqueId,
          hour: _remidnerTime.hour,
          minute: _remidnerTime.minute,
          weekday: i + 1,
        );
      }
    }
  }

  void addDataHive() {
    if (_habitNameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedGoal == 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Empty Fields"),
          content: Text("Please fill in all the fields."),

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
        'key_${DateTime.now()}_${_habitNameController.text}',
        Habit(
          habitName: _habitNameController.text,
          description: _descriptionController.text,
          goalDays: _selectedGoal,
          reminderTime: convertTimetoDateTime(_remidnerTime),
          habitDays: _selectedDaysMap,
          timeAllocated: Duration(
            hours: _timePicked.hour,
            minutes: _timePicked.minute,
            seconds: _timePicked.second,
          ).inSeconds,
          timeUtilized: 0,
          currentStreak: 0,
          longestStreak: 0,
          streakDates: {},
          isPositive: isPositive,
          isCompleted: false,
          isPaused: false,
          startDate: DateTime.now(),
        ),
      );

      addReminder();

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      behavior: HitTestBehavior
          .translucent, // ensures taps on empty space are detected
      onTap: () {
        FocusScope.of(context).unfocus(); // dismiss keyboard
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add New Habit",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Theme.of(context).colorScheme.onSurface,
            ),
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
                  child: MyDropDown(
                    onChanged: (value) {
                      setState(() {
                        _selectedGoal = int.parse(
                          value!.split(" ")[0],
                        ); // addd condition here
                      });
                    },
                  ),
                ),
              ),

              Spacer(),

              Center(
                child: MyToggle(
                  selectedLabelIndex: (index) {
                    setState(() {
                      _selectedHabitIndex = index;
                      isPositive = index == 0 ? true : false;
                    });
                  },
                  selectedHabitIndex: _selectedHabitIndex,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ----------------------------
              // Duration Picker
              // ----------------------------
              Expanded(
                child: Card(
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.secondaryContainer
                      : Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: TimePickerSpinnerPopUp(
                      initTime: _timePicked,
                      mode: CupertinoDatePickerMode.time,
                      onChange: (dateTime) {
                        setState(() => _timePicked = dateTime);
                      },
                      timeWidgetBuilder: (dateTime) {
                        final formattedTime =
                            _timePicked.hour == 0 && _timePicked.minute == 0
                            ? "Duration"
                            : _timePicked.hour == 0
                            ? "${_timePicked.minute} Min"
                            : "${_timePicked.hour} Hr ${_timePicked.minute} Min";

                        return Center(
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDarkMode
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12),

              // ----------------------------
              // Reminder Time Picker
              // ----------------------------
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      showPicker(
                        value: _remidnerTime,
                        accentColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainer,
                        sunrise: const TimeOfDay(hour: 6, minute: 0),
                        sunset: const TimeOfDay(hour: 18, minute: 0),
                        onChange: (selectedTime) {
                          setState(() => _remidnerTime = selectedTime);
                        },
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0,
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FontAwesome.clock_solid,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _formatTimeOfDay(_remidnerTime),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// Helper method to format TimeOfDay nicely
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
              SizedBox(width: 6),
              MyFilledBtn(
                onTap: () => onFilledBtnTap("SAT"),
                isSelected: _selectedDaysMap["SAT"]!,
                day: "SAT",
              ),
              SizedBox(width: 6),
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              fixedSize: Size(160, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(20),
              ),
            ),

            onPressed: addDataHive,
            child: Text(
              "Add Habit",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/models/habit.dart';
import 'package:niyama/services/noti_service.dart';
import 'package:niyama/widgets/my_drop_down.dart';
import 'package:niyama/widgets/my_filled_btn.dart';
import 'package:niyama/widgets/my_text_field.dart';
import 'package:niyama/widgets/my_toggle.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class HabitEditPage extends StatefulWidget {
  const HabitEditPage({required this.index, super.key});

  final int index;

  @override
  State<HabitEditPage> createState() => _HabitEditPageState();
}

class _HabitEditPageState extends State<HabitEditPage> {
  late Habit myHabit;
  late int _selectedGoal;
  late bool isPositive;
  late Map<String, bool> _selectedDaysMap;
  late int _selectedHabitIndex;

  late DateTime _timePicked;

  @override
  void initState() {
    myHabit = boxHabit.getAt(widget.index);
    _selectedGoal = myHabit.goalDays;
    isPositive = myHabit.isPositive;
    _selectedDaysMap = myHabit.habitDays;

    int totalSeconds = myHabit.timeAllocated; // e.g., 1410
    int hours = (totalSeconds ~/ 3600) % 24;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    _timePicked = DateTime.utc(
      0, // year
      1, // month
      1, // day
      hours,
      minutes,
      seconds,
    );

    _selectedHabitIndex = isPositive ? 0 : 1;
    super.initState();
  }

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

  void onFilledBtnTap(String day) {
    setState(() {
      _selectedDaysMap[day] = !_selectedDaysMap[day]!;
    });
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

  final _habitNameController = TextEditingController();
  final _descriptionController = TextEditingController();

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
      boxHabit.putAt(
        widget.index,
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
          timeUtilized: myHabit.timeUtilized,
          currentStreak: myHabit.currentStreak,
          longestStreak: myHabit.longestStreak,
          streakDates: myHabit.streakDates,
          isPositive: isPositive,
          isCompleted: myHabit.isCompleted,
          isPaused: myHabit.isPaused,
          startDate: myHabit.startDate,
          lastStartTime: null,
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 140),
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Text(
                "Edit Habit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 40),

              MyTextField(
                nameController: _habitNameController,
                hintText: myHabit.habitName,
              ),
              SizedBox(height: 12),

              MyTextField(
                nameController: _descriptionController,
                hintText: myHabit.description,
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 124,
                    child: Center(
                      child: MyDropDown(
                        hintText: myHabit.goalDays.toString(),
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
                  Visibility(
                    visible: isPositive,
                    child: Expanded(
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
                                  _timePicked.hour == 0 &&
                                      _timePicked.minute == 0
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
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  Visibility(visible: isPositive, child: SizedBox(width: 12)),

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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.errorContainer,
                      fixedSize: Size(140, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                    ),

                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      fixedSize: Size(140, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                    ),

                    onPressed: addDataHive,
                    child: Text(
                      "Save Habit",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

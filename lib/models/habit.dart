import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit {
  Habit({
    required this.habitName,
    required this.description,
    required this.goalDays,
    required this.reminderTime,
    required this.habitDays,
    required this.timeAllocated,
    required this.timeUtilized,
    required this.currentStreak,
    required this.longestStreak,
    required this.streakDates,
  });

  @HiveField(0)
  String habitName;

  @HiveField(1)
  String description;

  @HiveField(2)
  String goalDays;

  @HiveField(3)
  DateTime reminderTime;

  @HiveField(4)
  Map<String, bool> habitDays = {
    "MON": false,
    "TUE": false,
    "WED": false,
    "THU": false,
    "FRI": false,
    "SAT": false,
    "SUN": false,
  };

  @HiveField(5)
  DateTime timeAllocated;

  @HiveField(6)
  DateTime timeUtilized;

  @HiveField(7)
  int currentStreak;

  @HiveField(8)
  int longestStreak;

  @HiveField(9)
  Map<String, double> streakDates;
}

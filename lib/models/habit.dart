import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit extends HiveObject {
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
    required this.isPositive,
    required this.isCompleted,
    required this.isPaused,
    required this.startDate,
  });

  @HiveField(0)
  String habitName;

  @HiveField(1)
  String description;

  @HiveField(2)
  int goalDays;

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
  int timeAllocated; // saved as seconds

  @HiveField(6)
  int timeUtilized; // saved as seconds

  @HiveField(7)
  int currentStreak;

  @HiveField(8)
  int longestStreak;

  @HiveField(9)
  Map<String, int> streakDates;

  @HiveField(10)
  bool isPositive;

  @HiveField(11)
  bool isCompleted = false;

  @HiveField(12)
  bool isPaused = false;

  @HiveField(13)
  DateTime startDate;
}

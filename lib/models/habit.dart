import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit {
  Habit({
    required this.habitName,
    required this.description,
    required this.category,
    required this.reminderTime,
    required this.habitFreq,
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
  String category;

  @HiveField(3)
  DateTime reminderTime;

  @HiveField(4)
  List<String> habitFreq;

  @HiveField(5)
  double timeAllocated;

  @HiveField(6)
  double timeUtilized;

  @HiveField(7)
  int currentStreak;

  @HiveField(8)
  int longestStreak;

  @HiveField(9)
  List<Map<String, double>> streakDates;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 1;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      habitName: fields[0] as String,
      description: fields[1] as String,
      goalDays: fields[2] as int,
      reminderTime: fields[3] as DateTime,
      habitDays: (fields[4] as Map).cast<String, bool>(),
      timeAllocated: fields[5] as DateTime,
      timeUtilized: fields[6] as DateTime,
      currentStreak: fields[7] as int,
      longestStreak: fields[8] as int,
      streakDates: (fields[9] as Map).cast<String, double>(),
      isPositive: (fields[10] as bool),
      isCompleted: (fields[11] as bool),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.habitName)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.goalDays)
      ..writeByte(3)
      ..write(obj.reminderTime)
      ..writeByte(4)
      ..write(obj.habitDays)
      ..writeByte(5)
      ..write(obj.timeAllocated)
      ..writeByte(6)
      ..write(obj.timeUtilized)
      ..writeByte(7)
      ..write(obj.currentStreak)
      ..writeByte(8)
      ..write(obj.longestStreak)
      ..writeByte(9)
      ..write(obj.streakDates)
      ..writeByte(10)
      ..write(obj.isPositive)
      ..writeByte(11)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

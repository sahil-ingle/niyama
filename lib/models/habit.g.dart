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
      category: fields[2] as String,
      reminderTime: fields[3] as DateTime,
      habitFreq: (fields[4] as List).cast<String>(),
      timeAllocated: fields[5] as double,
      timeUtilized: fields[6] as double,
      currentStreak: fields[7] as int,
      longestStreak: fields[8] as int,
      streakDates: (fields[9] as List)
          .map((dynamic e) => (e as Map).cast<String, double>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.habitName)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.reminderTime)
      ..writeByte(4)
      ..write(obj.habitFreq)
      ..writeByte(5)
      ..write(obj.timeAllocated)
      ..writeByte(6)
      ..write(obj.timeUtilized)
      ..writeByte(7)
      ..write(obj.currentStreak)
      ..writeByte(8)
      ..write(obj.longestStreak)
      ..writeByte(9)
      ..write(obj.streakDates);
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

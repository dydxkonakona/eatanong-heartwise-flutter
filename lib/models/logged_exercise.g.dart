// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoggedExerciseAdapter extends TypeAdapter<LoggedExercise> {
  @override
  final int typeId = 4;

  @override
  LoggedExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoggedExercise(
      duration: fields[0] as double,
      loggedTime: fields[1] as DateTime,
      exercise: fields[2] as Exercise,
      person: fields[3] as Person,
    );
  }

  @override
  void write(BinaryWriter writer, LoggedExercise obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.duration)
      ..writeByte(1)
      ..write(obj.loggedTime)
      ..writeByte(2)
      ..write(obj.exercise)
      ..writeByte(3)
      ..write(obj.person);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoggedExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

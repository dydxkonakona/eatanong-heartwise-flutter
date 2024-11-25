// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicationReminderAdapter extends TypeAdapter<MedicationReminder> {
  @override
  final int typeId = 6;

  @override
  MedicationReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicationReminder(
      name: fields[0] as String,
      dosage: fields[1] as String,
      time: fields[2] as DateTime,
      isTaken: fields[3] as bool,
      specialInstructions: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicationReminder obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dosage)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.isTaken)
      ..writeByte(4)
      ..write(obj.specialInstructions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_totals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyTotalsAdapter extends TypeAdapter<DailyTotals> {
  @override
  final int typeId = 3;

  @override
  DailyTotals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyTotals(
      date: fields[0] as DateTime,
      totalCalories: fields[1] as double,
      totalFat: fields[2] as double,
      totalProtein: fields[3] as double,
      totalCarbohydrates: fields[4] as double,
      totalSodium: fields[5] as double,
      totalCholesterol: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailyTotals obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.totalCalories)
      ..writeByte(2)
      ..write(obj.totalFat)
      ..writeByte(3)
      ..write(obj.totalProtein)
      ..writeByte(4)
      ..write(obj.totalCarbohydrates)
      ..writeByte(5)
      ..write(obj.totalSodium)
      ..writeByte(6)
      ..write(obj.totalCholesterol);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyTotalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

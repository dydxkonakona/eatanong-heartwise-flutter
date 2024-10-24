// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_food.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoggedFoodAdapter extends TypeAdapter<LoggedFood> {
  @override
  final int typeId = 2;

  @override
  LoggedFood read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoggedFood(
      quantity: fields[0] as double,
      loggedTime: fields[1] as DateTime,
      foodItem: fields[2] as FoodItem,
    );
  }

  @override
  void write(BinaryWriter writer, LoggedFood obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.loggedTime)
      ..writeByte(2)
      ..write(obj.foodItem);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoggedFoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

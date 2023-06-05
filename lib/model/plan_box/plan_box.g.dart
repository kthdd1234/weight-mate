// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlanBoxAdapter extends TypeAdapter<PlanBox> {
  @override
  final int typeId = 3;

  @override
  PlanBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanBox(
      id: fields[0] as String,
      type: fields[1] as String,
      title: fields[2] as String,
      name: fields[4] as String,
      startDateTime: fields[5] as DateTime,
      endDateTime: fields[6] as DateTime?,
      isAlarm: fields[7] as bool,
      alarmTime: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PlanBox obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.startDateTime)
      ..writeByte(6)
      ..write(obj.endDateTime)
      ..writeByte(7)
      ..write(obj.isAlarm)
      ..writeByte(8)
      ..write(obj.alarmTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

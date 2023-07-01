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
      priority: fields[3] as String,
      isAlarm: fields[5] as bool,
      alarmTime: fields[6] as DateTime?,
      alarmId: fields[7] as int?,
      createDateTime: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PlanBox obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.isAlarm)
      ..writeByte(6)
      ..write(obj.alarmTime)
      ..writeByte(7)
      ..write(obj.alarmId)
      ..writeByte(8)
      ..write(obj.createDateTime);
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

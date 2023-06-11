// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserBoxAdapter extends TypeAdapter<UserBox> {
  @override
  final int typeId = 1;

  @override
  UserBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBox(
      userId: fields[0] as String,
      tall: fields[1] as double,
      goalWeight: fields[2] as double,
      recordStartDateTime: fields[3] as DateTime,
      isAlarm: fields[4] as bool,
      alarmTime: fields[5] as DateTime?,
      alarmId: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserBox obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.tall)
      ..writeByte(2)
      ..write(obj.goalWeight)
      ..writeByte(3)
      ..write(obj.recordStartDateTime)
      ..writeByte(4)
      ..write(obj.isAlarm)
      ..writeByte(5)
      ..write(obj.alarmTime)
      ..writeByte(6)
      ..write(obj.alarmId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

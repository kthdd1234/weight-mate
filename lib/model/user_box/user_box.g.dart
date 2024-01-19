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
      createDateTime: fields[3] as DateTime,
      isAlarm: fields[4] as bool,
      alarmTime: fields[5] as DateTime?,
      alarmId: fields[6] as int?,
      screenLockPasswords: fields[7] as String?,
      planViewType: fields[8] as String?,
      filterList: fields[9] as List<String>?,
      displayList: fields[10] as List<String>?,
    );
  }

  @override
  void write(BinaryWriter writer, UserBox obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.tall)
      ..writeByte(2)
      ..write(obj.goalWeight)
      ..writeByte(3)
      ..write(obj.createDateTime)
      ..writeByte(4)
      ..write(obj.isAlarm)
      ..writeByte(5)
      ..write(obj.alarmTime)
      ..writeByte(6)
      ..write(obj.alarmId)
      ..writeByte(7)
      ..write(obj.screenLockPasswords)
      ..writeByte(8)
      ..write(obj.planViewType)
      ..writeByte(9)
      ..write(obj.filterList)
      ..writeByte(10)
      ..write(obj.displayList);
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

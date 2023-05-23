// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoBoxAdapter extends TypeAdapter<UserInfoBox> {
  @override
  final int typeId = 1;

  @override
  UserInfoBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfoBox(
      tall: fields[0] as double,
      goalWeight: fields[1] as double,
      startDietDateTime: fields[2] as DateTime,
      endDietDateTime: fields[3] as DateTime?,
      recordStartDateTime: fields[4] as DateTime,
      recordInfoList: (fields[5] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, UserInfoBox obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.tall)
      ..writeByte(1)
      ..write(obj.goalWeight)
      ..writeByte(2)
      ..write(obj.startDietDateTime)
      ..writeByte(3)
      ..write(obj.endDietDateTime)
      ..writeByte(4)
      ..write(obj.recordStartDateTime)
      ..writeByte(5)
      ..write(obj.recordInfoList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

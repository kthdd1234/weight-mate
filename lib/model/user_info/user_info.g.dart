// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoAdapter extends TypeAdapter<UserInfo> {
  @override
  final int typeId = 1;

  @override
  UserInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfo(
      recordDateTime: fields[0] as DateTime,
      tall: fields[1] as double,
      weight: fields[2] as double,
      goalWeight: fields[3] as double,
      startDietDateTime: fields[5] as DateTime,
      endDietDateTime: fields[6] as DateTime,
      dietPlanList: (fields[7] as List).cast<DietPlanClass>(),
      bodyFat: fields[4] as double,
      memo: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserInfo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.recordDateTime)
      ..writeByte(1)
      ..write(obj.tall)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.goalWeight)
      ..writeByte(4)
      ..write(obj.bodyFat)
      ..writeByte(5)
      ..write(obj.startDietDateTime)
      ..writeByte(6)
      ..write(obj.endDietDateTime)
      ..writeByte(7)
      ..write(obj.dietPlanList)
      ..writeByte(8)
      ..write(obj.memo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

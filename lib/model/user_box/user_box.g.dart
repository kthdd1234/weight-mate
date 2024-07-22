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
      planViewType: fields[8] as String?,
      alarmTime: fields[5] as DateTime?,
      alarmId: fields[6] as int?,
      screenLockPasswords: fields[7] as String?,
      filterList: (fields[9] as List?)?.cast<String>(),
      displayList: (fields[10] as List?)?.cast<String>(),
      calendarFormat: fields[12] as String?,
      calendarMaker: fields[11] as String?,
      dietOrderList: (fields[13] as List?)?.cast<String>(),
      exerciseOrderList: (fields[14] as List?)?.cast<String>(),
      lifeOrderList: (fields[15] as List?)?.cast<String>(),
      language: fields[16] as String?,
      tallUnit: fields[18] as String?,
      weightUnit: fields[17] as String?,
      isShowPreviousGraph: fields[19] as bool?,
      historyForamt: fields[20] as String?,
      historyDisplayList: (fields[21] as List?)?.cast<String>(),
      historyCalendarFormat: fields[22] as String?,
      isDietExerciseRecordDateTime: fields[23] as bool?,
      fontFamily: fields[24] as String?,
      googleDriveInfo: (fields[25] as Map?)?.cast<String, dynamic>(),
      isDietExerciseRecordDateTime2: fields[26] as bool?,
      customerInfoJson: (fields[27] as Map?)?.cast<String, dynamic>(),
      graphType: fields[28] as String?,
      cutomGraphStartDateTime: fields[29] as DateTime?,
      cutomGraphEndDateTime: fields[30] as DateTime?,
      hashTagList: (fields[31] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      searchDisplayList: (fields[32] as List?)?.cast<String>(),
      appStartIndex: fields[33] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserBox obj) {
    writer
      ..writeByte(34)
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
      ..write(obj.displayList)
      ..writeByte(11)
      ..write(obj.calendarMaker)
      ..writeByte(12)
      ..write(obj.calendarFormat)
      ..writeByte(13)
      ..write(obj.dietOrderList)
      ..writeByte(14)
      ..write(obj.exerciseOrderList)
      ..writeByte(15)
      ..write(obj.lifeOrderList)
      ..writeByte(16)
      ..write(obj.language)
      ..writeByte(17)
      ..write(obj.weightUnit)
      ..writeByte(18)
      ..write(obj.tallUnit)
      ..writeByte(19)
      ..write(obj.isShowPreviousGraph)
      ..writeByte(20)
      ..write(obj.historyForamt)
      ..writeByte(21)
      ..write(obj.historyDisplayList)
      ..writeByte(22)
      ..write(obj.historyCalendarFormat)
      ..writeByte(23)
      ..write(obj.isDietExerciseRecordDateTime)
      ..writeByte(24)
      ..write(obj.fontFamily)
      ..writeByte(25)
      ..write(obj.googleDriveInfo)
      ..writeByte(26)
      ..write(obj.isDietExerciseRecordDateTime2)
      ..writeByte(27)
      ..write(obj.customerInfoJson)
      ..writeByte(28)
      ..write(obj.graphType)
      ..writeByte(29)
      ..write(obj.cutomGraphStartDateTime)
      ..writeByte(30)
      ..write(obj.cutomGraphEndDateTime)
      ..writeByte(31)
      ..write(obj.hashTagList)
      ..writeByte(32)
      ..write(obj.searchDisplayList)
      ..writeByte(33)
      ..write(obj.appStartIndex);
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

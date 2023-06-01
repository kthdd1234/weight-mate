// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'act_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActBoxAdapter extends TypeAdapter<ActBox> {
  @override
  final int typeId = 3;

  @override
  ActBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActBox(
      id: fields[0] as String,
      mainActType: fields[1] as String,
      mainActTitle: fields[2] as String,
      subActType: fields[3] as String,
      subActTitle: fields[4] as String,
      startActDateTime: fields[5] as DateTime,
      endActDateTime: fields[6] as DateTime?,
      isAlarm: fields[7] as bool,
      alarmTime: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ActBox obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mainActType)
      ..writeByte(2)
      ..write(obj.mainActTitle)
      ..writeByte(3)
      ..write(obj.subActType)
      ..writeByte(4)
      ..write(obj.subActTitle)
      ..writeByte(5)
      ..write(obj.startActDateTime)
      ..writeByte(6)
      ..write(obj.endActDateTime)
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
      other is ActBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

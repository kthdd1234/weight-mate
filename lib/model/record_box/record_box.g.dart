// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordBoxAdapter extends TypeAdapter<RecordBox> {
  @override
  final int typeId = 2;

  @override
  RecordBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordBox(
      createDateTime: fields[0] as DateTime,
      weightDateTime: fields[1] as DateTime?,
      actionDateTime: fields[2] as DateTime?,
      diaryDateTime: fields[3] as DateTime?,
      weight: fields[4] as double?,
      actions: (fields[5] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      leftEyeBodyFilePath: fields[6] as String?,
      rightEyeBodyFilePath: fields[7] as String?,
      whiteText: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecordBox obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.createDateTime)
      ..writeByte(1)
      ..write(obj.weightDateTime)
      ..writeByte(2)
      ..write(obj.actionDateTime)
      ..writeByte(3)
      ..write(obj.diaryDateTime)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.actions)
      ..writeByte(6)
      ..write(obj.leftEyeBodyFilePath)
      ..writeByte(7)
      ..write(obj.rightEyeBodyFilePath)
      ..writeByte(8)
      ..write(obj.whiteText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

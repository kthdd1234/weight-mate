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
        leftFile: fields[6] as Uint8List?,
        rightFile: fields[7] as Uint8List?,
        whiteText: fields[8] as String?,
        emotion: fields[9] as String?,
        bottomFile: fields[10] as Uint8List?,
        topFile: fields[11] as Uint8List?,
        dietRecordOrderList: (fields[12] as List?)?.cast<String>(),
        exerciseRecordOrderList: (fields[13] as List?)?.cast<String>());
  }

  @override
  void write(BinaryWriter writer, RecordBox obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.leftFile)
      ..writeByte(7)
      ..write(obj.rightFile)
      ..writeByte(8)
      ..write(obj.whiteText)
      ..writeByte(9)
      ..write(obj.emotion)
      ..writeByte(10)
      ..write(obj.bottomFile)
      ..writeByte(11)
      ..write(obj.topFile)
      ..writeByte(12)
      ..write(obj.dietRecordOrderList)
      ..writeByte(13)
      ..write(obj.exerciseRecordOrderList);
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

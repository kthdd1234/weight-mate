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
      recordDateTime: fields[0] as DateTime,
      weight: fields[1] as double?,
      actions: (fields[2] as List?)?.cast<String>(),
      memo: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecordBox obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.recordDateTime)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.actions)
      ..writeByte(3)
      ..write(obj.memo);
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

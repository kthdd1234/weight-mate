// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordInfoBoxAdapter extends TypeAdapter<RecordInfoBox> {
  @override
  final int typeId = 3;

  @override
  RecordInfoBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordInfoBox(
      recordDateTime: fields[0] as DateTime?,
      weight: fields[1] as double?,
      dietPlanList: (fields[2] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      memo: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecordInfoBox obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.recordDateTime)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.dietPlanList)
      ..writeByte(3)
      ..write(obj.memo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordInfoBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

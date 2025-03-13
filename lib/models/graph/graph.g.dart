// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GraphAdapter extends TypeAdapter<Graph> {
  @override
  final int typeId = 3;

  @override
  Graph read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Graph(
      employeeKey: fields[0] as int?,
      workStartDate: fields[1] as DateTime?,
      workEndDate: fields[2] as DateTime?,
      timeStart: fields[3] as String?,
      timeEnd: fields[4] as String?,
      offStartDate: fields[5] as DateTime?,
      offEndDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Graph obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.employeeKey)
      ..writeByte(1)
      ..write(obj.workStartDate)
      ..writeByte(2)
      ..write(obj.workEndDate)
      ..writeByte(3)
      ..write(obj.timeStart)
      ..writeByte(4)
      ..write(obj.timeEnd)
      ..writeByte(5)
      ..write(obj.offStartDate)
      ..writeByte(6)
      ..write(obj.offEndDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GraphAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

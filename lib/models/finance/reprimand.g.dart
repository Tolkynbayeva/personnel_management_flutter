// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reprimand.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReprimandAdapter extends TypeAdapter<Reprimand> {
  @override
  final int typeId = 4;

  @override
  Reprimand read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reprimand(
      employeeName: fields[0] as String,
      info: fields[1] as String,
      rebuke: fields[2] as String,
      date: fields[3] as DateTime,
      sum: fields[4] as double,
      comment: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Reprimand obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.employeeName)
      ..writeByte(1)
      ..write(obj.info)
      ..writeByte(2)
      ..write(obj.rebuke)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.sum)
      ..writeByte(5)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReprimandAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

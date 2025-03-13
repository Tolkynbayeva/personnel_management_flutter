// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedbackModelAdapter extends TypeAdapter<FeedbackModel> {
  @override
  final int typeId = 1;

  @override
  FeedbackModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedbackModel(
      rating: fields[0] as int,
      text: fields[1] as String,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FeedbackModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.rating)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

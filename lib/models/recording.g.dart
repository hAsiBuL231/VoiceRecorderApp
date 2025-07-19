// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordingAdapter extends TypeAdapter<Recording> {
  @override
  final int typeId = 0;

  @override
  Recording read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read()};
    return Recording(
      id: fields[0] as String,
      path: fields[1] as String,
      createdAt: fields[2] as DateTime,
      duration: fields[3] as Duration,
      note: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Recording obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecordingAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

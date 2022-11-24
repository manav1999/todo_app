// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_payload.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePayloadAdapter extends TypeAdapter<HivePayload> {
  @override
  final int typeId = 1;

  @override
  HivePayload read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePayload(
      id: fields[0] as String,
      data: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HivePayload obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePayloadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

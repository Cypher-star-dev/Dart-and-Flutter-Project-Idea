// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_tier.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RateTierAdapter extends TypeAdapter<RateTier> {
  @override
  final int typeId = 5;

  @override
  RateTier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RateTier(
      id: fields[0] as String,
      houseId: fields[1] as String,
      source: fields[2] as EnergySource,
      minKwh: fields[3] as double,
      maxKwh: fields[4] as double,
      ratePerKwh: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RateTier obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.houseId)
      ..writeByte(2)
      ..write(obj.source)
      ..writeByte(3)
      ..write(obj.minKwh)
      ..writeByte(4)
      ..write(obj.maxKwh)
      ..writeByte(5)
      ..write(obj.ratePerKwh);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RateTierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

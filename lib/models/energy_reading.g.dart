// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_reading.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnergyReadingAdapter extends TypeAdapter<EnergyReading> {
  @override
  final int typeId = 2;

  @override
  EnergyReading read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnergyReading(
      id: fields[0] as String,
      houseId: fields[1] as String,
      timestamp: fields[2] as DateTime,
      kwhUsed: fields[3] as double,
      costPaid: fields[4] as double,
      source: fields[5] as EnergySource,
    );
  }

  @override
  void write(BinaryWriter writer, EnergyReading obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.houseId)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.kwhUsed)
      ..writeByte(4)
      ..write(obj.costPaid)
      ..writeByte(5)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnergyReadingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

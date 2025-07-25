// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HouseAdapter extends TypeAdapter<House> {
  @override
  final int typeId = 1;

  @override
  House read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return House(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      lastUpdated: fields[3] as DateTime,
      currentBalance: fields[4] as double,
      currentKWhConsumption: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, House obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.lastUpdated)
      ..writeByte(4)
      ..write(obj.currentBalance)
      ..writeByte(5)
      ..write(obj.currentKWhConsumption);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HouseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

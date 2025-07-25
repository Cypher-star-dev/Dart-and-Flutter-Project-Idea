// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_limit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnergyLimitAdapter extends TypeAdapter<EnergyLimit> {
  @override
  final int typeId = 4;

  @override
  EnergyLimit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnergyLimit(
      id: fields[0] as String,
      houseId: fields[1] as String,
      type: fields[2] as LimitType,
      limitValue: fields[3] as double,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EnergyLimit obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.houseId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.limitValue)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnergyLimitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LimitTypeAdapter extends TypeAdapter<LimitType> {
  @override
  final int typeId = 3;

  @override
  LimitType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LimitType.monetary;
      case 1:
        return LimitType.kwhConsumption;
      default:
        return LimitType.monetary;
    }
  }

  @override
  void write(BinaryWriter writer, LimitType obj) {
    switch (obj) {
      case LimitType.monetary:
        writer.writeByte(0);
        break;
      case LimitType.kwhConsumption:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LimitTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

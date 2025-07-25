// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_source.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnergySourceAdapter extends TypeAdapter<EnergySource> {
  @override
  final int typeId = 0;

  @override
  EnergySource read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EnergySource.solar;
      case 1:
        return EnergySource.gas;
      case 2:
        return EnergySource.poleElectricity;
      default:
        return EnergySource.solar;
    }
  }

  @override
  void write(BinaryWriter writer, EnergySource obj) {
    switch (obj) {
      case EnergySource.solar:
        writer.writeByte(0);
        break;
      case EnergySource.gas:
        writer.writeByte(1);
        break;
      case EnergySource.poleElectricity:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnergySourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

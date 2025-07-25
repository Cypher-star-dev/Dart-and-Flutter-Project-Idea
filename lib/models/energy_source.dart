// lib/models/energy_source.dart

import 'package:hive/hive.dart';

part 'energy_source.g.dart'; // Generated file

@HiveType(typeId: 0)
enum EnergySource {
  @HiveField(0)
  solar,
  @HiveField(1)
  gas,
  @HiveField(2)
  poleElectricity,
}

extension EnergySourceExtension on EnergySource {
  String toDisplayString() {
    switch (this) {
      case EnergySource.solar:
        return 'Solar';
      case EnergySource.gas:
        return 'Gas';
      case EnergySource.poleElectricity:
        return 'Pole Electricity';
    }
  }
}
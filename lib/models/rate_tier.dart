// lib/models/rate_tier.dart

import 'package:hive/hive.dart';
import 'energy_source.dart';

part 'rate_tier.g.dart'; // Generated file

@HiveType(typeId: 5)
class RateTier extends HiveObject {
  @HiveField(0)
  late String id; // Unique ID for the rate tier
  @HiveField(1)
  late String houseId; // Link to the house
  @HiveField(2)
  late EnergySource source; // Which energy source this rate applies to
  @HiveField(3)
  late double minKwh; // Minimum kWh for this tier
  @HiveField(4)
  late double maxKwh; // Maximum kWh for this tier (use -1 for "unlimited")
  @HiveField(5)
  late double ratePerKwh; // Cost per kWh for this tier

  RateTier({
    required this.id,
    required this.houseId,
    required this.source,
    required this.minKwh,
    required this.maxKwh,
    required this.ratePerKwh,
  });
}
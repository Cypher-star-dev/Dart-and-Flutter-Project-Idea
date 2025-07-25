// lib/models/energy_reading.dart

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'energy_source.dart';

part 'energy_reading.g.dart'; // Generated file

@HiveType(typeId: 2)
class EnergyReading extends HiveObject {
  @HiveField(0)
  late String id; // Unique ID for the reading
  @HiveField(1)
  late String houseId; // Link to the house
  @HiveField(2)
  late DateTime timestamp;
  @HiveField(3)
  late double kwhUsed;
  @HiveField(4)
  late double costPaid;
  @HiveField(5)
  late EnergySource source;

  EnergyReading({
    required this.id,
    required this.houseId,
    required this.timestamp,
    required this.kwhUsed,
    required this.costPaid,
    required this.source,
  });

  String get formattedTimestamp {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp);
  }

  // Calculate cost per kWh for this reading
  double get costPerKwh {
    if (kwhUsed == 0) return 0.0; // Avoid division by zero
    return costPaid / kwhUsed;
  }
}
// lib/models/energy_limit.dart

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'energy_limit.g.dart'; // Generated file

@HiveType(typeId: 3)
enum LimitType {
  @HiveField(0)
  monetary, // e.g., $100/month
  @HiveField(1)
  kwhConsumption, // e.g., 500 kWh/month
}

@HiveType(typeId: 4)
class EnergyLimit extends HiveObject {
  @HiveField(0)
  late String id; // Unique ID for the limit
  @HiveField(1)
  late String houseId; // Link to the house
  @HiveField(2)
  late LimitType type;
  @HiveField(3)
  late double limitValue;
  @HiveField(4)
  late DateTime startDate;
  @HiveField(5)
  late DateTime endDate;
  @HiveField(6)
  late bool isActive; // Whether this limit is currently active

  EnergyLimit({
    required this.id,
    required this.houseId,
    required this.type,
    required this.limitValue,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });

  String get formattedPeriod {
    return '${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}';
  }
}
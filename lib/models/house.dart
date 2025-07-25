// lib/models/house.dart

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'house.g.dart'; // Generated file

@HiveType(typeId: 1)
class House extends HiveObject {
  @HiveField(0)
  late String id; // Unique ID for the house
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String address; // Added for more realism, optional
  @HiveField(3)
  late DateTime lastUpdated;
  @HiveField(4)
  late double currentBalance; // To track spending if limits are monetary
  @HiveField(5)
  late double currentKWhConsumption; // To track consumption if limits are kWh

  House({
    required this.id,
    required this.name,
    required this.address,
    required this.lastUpdated,
    this.currentBalance = 0.0,
    this.currentKWhConsumption = 0.0,
  });

  // Factory constructor to create a House from a map (useful for mock data or API)
  factory House.fromMap(Map<String, dynamic> map) {
    return House(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
      currentBalance: map['currentBalance'] ?? 0.0,
      currentKWhConsumption: map['currentKWhConsumption'] ?? 0.0,
    );
  }

  // Convert House to a map (useful for saving to JSON or API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'lastUpdated': lastUpdated.toIso8601String(),
      'currentBalance': currentBalance,
      'currentKWhConsumption': currentKWhConsumption,
    };
  }

  String get formattedLastUpdated {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(lastUpdated);
  }
}
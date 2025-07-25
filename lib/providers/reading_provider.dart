// lib/providers/reading_provider.dart

import 'package:flutter/material.dart';
import 'package:energy_monitor/models/energy_reading.dart';
import 'package:energy_monitor/models/energy_source.dart';
import 'package:energy_monitor/models/house.dart';
import 'package:energy_monitor/services/database_service.dart'; // Now uses static methods
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart'; // Import for firstWhereOrNull

class ReadingProvider with ChangeNotifier {
  // No longer need to instantiate DatabaseService as its methods will be static
  // final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();

  List<EnergyReading> _readings = []; // This might still be useful for a global list
  Map<String, List<EnergyReading>> _readingsByHouse = {};

  // Get readings for a specific house
  List<EnergyReading> getReadingsForHouse(String houseId) {
    if (!_readingsByHouse.containsKey(houseId)) {
      _readingsByHouse[houseId] = DatabaseService.getReadingsForHouse(houseId); // Call static method
    }
    return _readingsByHouse[houseId]!;
  }

  // Add a new energy reading
  Future<void> addEnergyReading({
    required String houseId,
    required DateTime timestamp,
    required double kwhUsed,
    required double costPaid,
    required EnergySource source,
  }) async {
    final newReading = EnergyReading(
      id: _uuid.v4(),
      houseId: houseId,
      timestamp: timestamp,
      kwhUsed: kwhUsed,
      costPaid: costPaid,
      source: source,
    );

    await DatabaseService.addReading(newReading); // Call static method

    // Update local cache
    if (_readingsByHouse.containsKey(houseId)) {
      _readingsByHouse[houseId]!.add(newReading);
    } else {
      _readingsByHouse[houseId] = [newReading];
    }

    // Update house's last updated time and current usage stats
    House? house = DatabaseService.getHouses().firstWhereOrNull( // Use firstWhereOrNull
      (h) => h.id == houseId,
    );

    if (house != null) {
      house.lastUpdated = DateTime.now();
      house.currentBalance += costPaid;
      house.currentKWhConsumption += kwhUsed;
      await DatabaseService.updateHouse(house); // Call static method
      // Notify HouseProvider about the change in house stats
      // This requires accessing HouseProvider from here, which can be done via context or by
      // having a reference passed (more complex). For simplicity now, we'll let HouseDetailScreen's
      // consumer of HouseProvider handle its own rebuild, but it won't be immediate here.
      // A better long-term solution involves directly updating the HouseProvider's state or using a callback.
    }

    notifyListeners();
  }

  // Update an existing energy reading
  Future<void> updateEnergyReading(EnergyReading updatedReading) async {
    final oldReading = _readingsByHouse[updatedReading.houseId]
        ?.firstWhereOrNull((r) => r.id == updatedReading.id); // Use firstWhereOrNull

    House? house = DatabaseService.getHouses().firstWhereOrNull( // Use firstWhereOrNull
      (h) => h.id == updatedReading.houseId,
    );

    if (house != null && oldReading != null) {
      house.currentBalance -= oldReading.costPaid;
      house.currentKWhConsumption -= oldReading.kwhUsed;
    }

    await DatabaseService.updateReading(updatedReading); // Call static method

    // Update local cache
    final houseReadings = _readingsByHouse[updatedReading.houseId];
    if (houseReadings != null) {
      final index = houseReadings.indexWhere((r) => r.id == updatedReading.id);
      if (index != -1) {
        houseReadings[index] = updatedReading;
      }
    }

    // After updating, add new values to house totals
    if (house != null) {
      house.currentBalance += updatedReading.costPaid;
      house.currentKWhConsumption += updatedReading.kwhUsed;
      house.lastUpdated = DateTime.now();
      await DatabaseService.updateHouse(house); // Call static method
    }

    notifyListeners();
  }

  // Delete an energy reading
  Future<void> deleteEnergyReading(String readingId, String houseId) async {
    final readingToDelete = _readingsByHouse[houseId]
        ?.firstWhereOrNull((r) => r.id == readingId); // Use firstWhereOrNull

    House? house = DatabaseService.getHouses().firstWhereOrNull( // Use firstWhereOrNull
      (h) => h.id == houseId,
    );

    if (house != null && readingToDelete != null) {
      house.currentBalance -= readingToDelete.costPaid;
      house.currentKWhConsumption -= readingToDelete.kwhUsed;
      house.lastUpdated = DateTime.now();
      await DatabaseService.updateHouse(house); // Call static method
    }

    await DatabaseService.deleteReading(readingId); // Call static method

    // Update local cache
    _readingsByHouse[houseId]?.removeWhere((r) => r.id == readingId);
    notifyListeners();
  }

  // Refresh readings for a specific house (e.g., after an external update)
  Future<void> refreshReadingsForHouse(String houseId) async {
    _readingsByHouse[houseId] = DatabaseService.getReadingsForHouse(houseId); // Call static method
    notifyListeners();
  }
}
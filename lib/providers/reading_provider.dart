// lib/providers/reading_provider.dart

import 'package:flutter/material.dart';
import 'package:energy_monitor/models/energy_reading.dart';
import 'package:energy_monitor/models/energy_source.dart';
import 'package:energy_monitor/models/house.dart'; // To potentially update house stats
import 'package:energy_monitor/services/database_service.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

class ReadingProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();

  List<EnergyReading> _readings = [];
  Map<String, List<EnergyReading>> _readingsByHouse = {}; // Cache readings per house

  // Initial load of all readings (could be optimized later for large datasets)
  // For now, let's just get the readings for a specific house when requested.

  // Get readings for a specific house
  List<EnergyReading> getReadingsForHouse(String houseId) {
    if (!_readingsByHouse.containsKey(houseId)) {
      _readingsByHouse[houseId] = _databaseService.getReadingsForHouse(houseId);
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

    await _databaseService.addReading(newReading);

    // Update local cache
    if (_readingsByHouse.containsKey(houseId)) {
      _readingsByHouse[houseId]!.add(newReading);
    } else {
      _readingsByHouse[houseId] = [newReading];
    }

    // Optional: Update house's last updated time and current usage stats
    // You might want to do more complex calculations in CalculationService
    // For now, let's just update lastUpdated
    House? house = _databaseService.getHouses().firstWhere(
      (h) => h.id == houseId,
      orElse: () => null as House, // Handle case where house might not be found (shouldn't happen here)
    );

    if (house != null) {
      house.lastUpdated = DateTime.now();
      // For simplicity, we'll just increment current balance and kWh.
      // A more robust approach would be to recalculate monthly totals based on limits.
      house.currentBalance += costPaid;
      house.currentKWhConsumption += kwhUsed;
      await _databaseService.updateHouse(house); // Update house in DB
    }

    notifyListeners();
  }

  // Update an existing energy reading
  Future<void> updateEnergyReading(EnergyReading updatedReading) async {
    // Before updating, subtract old values from house totals
    final oldReading = _readingsByHouse[updatedReading.houseId]
        ?.firstWhere((r) => r.id == updatedReading.id, orElse: () => null as EnergyReading);

    House? house = _databaseService.getHouses().firstWhere(
      (h) => h.id == updatedReading.houseId,
      orElse: () => null as House,
    );

    if (house != null && oldReading != null) {
      house.currentBalance -= oldReading.costPaid;
      house.currentKWhConsumption -= oldReading.kwhUsed;
    }

    await _databaseService.updateReading(updatedReading);

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
      await _databaseService.updateHouse(house);
    }

    notifyListeners();
  }

  // Delete an energy reading
  Future<void> deleteEnergyReading(String readingId, String houseId) async {
    // Before deleting, subtract values from house totals
    final readingToDelete = _readingsByHouse[houseId]
        ?.firstWhere((r) => r.id == readingId, orElse: () => null as EnergyReading);

    House? house = _databaseService.getHouses().firstWhere(
      (h) => h.id == houseId,
      orElse: () => null as House,
    );

    if (house != null && readingToDelete != null) {
      house.currentBalance -= readingToDelete.costPaid;
      house.currentKWhConsumption -= readingToDelete.kwhUsed;
      house.lastUpdated = DateTime.now();
      await _databaseService.updateHouse(house);
    }

    await _databaseService.deleteReading(readingId);

    // Update local cache
    _readingsByHouse[houseId]?.removeWhere((r) => r.id == readingId);
    notifyListeners();
  }

  // Refresh readings for a specific house (e.g., after an external update)
  Future<void> refreshReadingsForHouse(String houseId) async {
    _readingsByHouse[houseId] = _databaseService.getReadingsForHouse(houseId);
    notifyListeners();
  }
}
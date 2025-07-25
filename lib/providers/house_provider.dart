// lib/providers/house_provider.dart

import 'package:flutter/material.dart';
import 'package:energy_monitor/models/house.dart';
import 'package:energy_monitor/services/database_service.dart'; // Import the static methods
import 'package:uuid/uuid.dart'; // Add uuid package for unique IDs
import 'package:collection/collection.dart'; // Import for firstWhereOrNull

class HouseProvider with ChangeNotifier {
  // No longer need to instantiate DatabaseService as its methods are static
  // final DatabaseService _databaseService = DatabaseService();
  // Instead, call DatabaseService.methodName() directly

  List<House> _houses = [];

  List<House> get houses => _houses;

  HouseProvider() {
    _loadHouses();
  }

  Future<void> _loadHouses() async {
    _houses = DatabaseService.getHouses(); // Call static method
    notifyListeners();
  }

  Future<void> addHouse(String name, String address) async {
    final newHouse = House(
      id: const Uuid().v4(), // Generate a unique ID
      name: name,
      address: address,
      lastUpdated: DateTime.now(),
      currentBalance: 0.0, // Initialize
      currentKWhConsumption: 0.0, // Initialize
    );
    await DatabaseService.addHouse(newHouse); // Call static method
    _houses.add(newHouse);
    notifyListeners();
  }

  Future<void> updateHouse(House updatedHouse) async {
    await DatabaseService.updateHouse(updatedHouse); // Call static method
    final index = _houses.indexWhere((house) => house.id == updatedHouse.id);
    if (index != -1) {
      _houses[index] = updatedHouse;
      notifyListeners();
    }
  }

  Future<void> deleteHouse(String houseId) async {
    await DatabaseService.deleteHouse(houseId); // Call static method
    _houses.removeWhere((house) => house.id == houseId);
    notifyListeners();
  }

  // You might add methods here to fetch a single house or other house-related logic
  House? getHouseById(String id) {
    return _houses.firstWhereOrNull((house) => house.id == id); // Use firstWhereOrNull
  }
}
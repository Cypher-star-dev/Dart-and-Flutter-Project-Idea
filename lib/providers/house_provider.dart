// lib/providers/house_provider.dart

import 'package:flutter/material.dart';
import 'package:energy_monitor/models/house.dart';
import 'package:energy_monitor/services/database_service.dart';
import 'package:uuid/uuid.dart'; // Add uuid package for unique IDs

class HouseProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<House> _houses = [];

  List<House> get houses => _houses;

  HouseProvider() {
    _loadHouses();
  }

  Future<void> _loadHouses() async {
    _houses = _databaseService.getHouses();
    notifyListeners();
  }

  Future<void> addHouse(String name, String address) async {
    final newHouse = House(
      id: const Uuid().v4(), // Generate a unique ID
      name: name,
      address: address,
      lastUpdated: DateTime.now(),
    );
    await _databaseService.addHouse(newHouse);
    _houses.add(newHouse);
    notifyListeners();
  }

  Future<void> updateHouse(House updatedHouse) async {
    await _databaseService.updateHouse(updatedHouse);
    final index = _houses.indexWhere((house) => house.id == updatedHouse.id);
    if (index != -1) {
      _houses[index] = updatedHouse;
      notifyListeners();
    }
  }

  Future<void> deleteHouse(String houseId) async {
    await _databaseService.deleteHouse(houseId);
    _houses.removeWhere((house) => house.id == houseId);
    notifyListeners();
  }

  // You might add methods here to fetch a single house or other house-related logic
  House? getHouseById(String id) {
    return _houses.firstWhere((house) => house.id == id, orElse: () => null as House); // Handle null case
  }
}
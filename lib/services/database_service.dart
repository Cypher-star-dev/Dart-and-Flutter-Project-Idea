// lib/services/database_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/energy_source.dart';
import '../models/house.dart';
import '../models/energy_reading.dart';
import '../models/energy_limit.dart';
import '../models/rate_tier.dart';

class DatabaseService {
  static late Box<House> _housesBox;
  static late Box<EnergyReading> _readingsBox;
  static late Box<EnergyLimit> _limitsBox;
  static late Box<RateTier> _rateTiersBox;

  static Future<void> init() async {
    // Initialize Hive
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Register Adapters
    Hive.registerAdapter(EnergySourceAdapter());
    Hive.registerAdapter(HouseAdapter());
    Hive.registerAdapter(EnergyReadingAdapter());
    Hive.registerAdapter(LimitTypeAdapter());
    Hive.registerAdapter(EnergyLimitAdapter());
    Hive.registerAdapter(RateTierAdapter());

    // Open Boxes
    _housesBox = await Hive.openBox<House>('houses');
    _readingsBox = await Hive.openBox<EnergyReading>('energy_readings');
    _limitsBox = await Hive.openBox<EnergyLimit>('energy_limits');
    _rateTiersBox = await Hive.openBox<RateTier>('rate_tiers');
  }

  // --- House Operations ---
  List<House> getHouses() {
    return _housesBox.values.toList();
  }

  Future<void> addHouse(House house) async {
    await _housesBox.put(house.id, house);
  }

  Future<void> updateHouse(House house) async {
    await _housesBox.put(house.id, house);
  }

  Future<void> deleteHouse(String houseId) async {
    await _housesBox.delete(houseId);
    // Also delete associated readings, limits, and rate tiers
    final readingsToDelete = _readingsBox.values.where((r) => r.houseId == houseId).map((r) => r.id).toList();
    await _readingsBox.deleteAll(readingsToDelete);
    final limitsToDelete = _limitsBox.values.where((l) => l.houseId == houseId).map((l) => l.id).toList();
    await _limitsBox.deleteAll(limitsToDelete);
    final rateTiersToDelete = _rateTiersBox.values.where((rt) => rt.houseId == houseId).map((rt) => rt.id).toList();
    await _rateTiersBox.deleteAll(rateTiersToDelete);
  }

  // --- EnergyReading Operations ---
  List<EnergyReading> getReadingsForHouse(String houseId) {
    return _readingsBox.values.where((reading) => reading.houseId == houseId).toList();
  }

  Future<void> addReading(EnergyReading reading) async {
    await _readingsBox.put(reading.id, reading);
  }

  Future<void> updateReading(EnergyReading reading) async {
    await _readingsBox.put(reading.id, reading);
  }

  Future<void> deleteReading(String readingId) async {
    await _readingsBox.delete(readingId);
  }

  // --- EnergyLimit Operations ---
  List<EnergyLimit> getLimitsForHouse(String houseId) {
    return _limitsBox.values.where((limit) => limit.houseId == houseId).toList();
  }

  Future<void> addLimit(EnergyLimit limit) async {
    await _limitsBox.put(limit.id, limit);
  }

  Future<void> updateLimit(EnergyLimit limit) async {
    await _limitsBox.put(limit.id, limit);
  }

  Future<void> deleteLimit(String limitId) async {
    await _limitsBox.delete(limitId);
  }

  // --- RateTier Operations ---
  List<RateTier> getRateTiersForHouse(String houseId) {
    return _rateTiersBox.values.where((tier) => tier.houseId == houseId).toList();
  }

  Future<void> addRateTier(RateTier tier) async {
    await _rateTiersBox.put(tier.id, tier);
  }

  Future<void> updateRateTier(RateTier tier) async {
    await _rateTiersBox.put(tier.id, tier);
  }

  Future<void> deleteRateTier(String tierId) async {
    await _rateTiersBox.delete(tierId);
  }
}
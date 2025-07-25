// lib/screens/house_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:energy_monitor/providers/house_provider.dart';
import 'package:energy_monitor/screens/add_house_screen.dart';
import 'package:energy_monitor/screens/house_detail_screen.dart';
import 'package:energy_monitor/widgets/house_card.dart';

class HouseListScreen extends StatelessWidget {
  const HouseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Houses'),
        automaticallyImplyLeading: false, // Hide back button on home screen
      ),
      body: Consumer<HouseProvider>(
        builder: (context, houseProvider, child) {
          if (houseProvider.houses.isEmpty) {
            return const Center(
              child: Text('No houses added yet. Tap + to add one!'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: houseProvider.houses.length,
            itemBuilder: (context, index) {
              final house = houseProvider.houses[index];
              return HouseCard(
                house: house,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HouseDetailScreen(houseId: house.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHouseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
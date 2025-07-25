// lib/screens/house_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:energy_monitor/models/house.dart';
import 'package:energy_monitor/providers/house_provider.dart';
// import 'package:energy_monitor/screens/add_reading_screen.dart'; // Will create these soon
// import 'package:energy_monitor/screens/limit_settings_screen.dart';
// import 'package:energy_monitor/screens/analytics_screen.dart';
// import 'package:energy_monitor/screens/export_screen.dart';

class HouseDetailScreen extends StatelessWidget {
  final String houseId;
  const HouseDetailScreen({super.key, required this.houseId});

  @override
  Widget build(BuildContext context) {
    final houseProvider = Provider.of<HouseProvider>(context);
    final House? house = houseProvider.getHouseById(houseId);

    if (house == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('House Not Found')),
        body: const Center(child: Text('The selected house could not be found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(house.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement Edit House functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit House functionality coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Show confirmation dialog before deleting
              final bool? confirmDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete House'),
                    content: Text('Are you sure you want to delete ${house.name} and all its associated data?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete == true) {
                await houseProvider.deleteHouse(house.id);
                if (context.mounted) {
                  Navigator.pop(context); // Go back to house list after deletion
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: ${house.address.isNotEmpty ? house.address : 'N/A'}', style: const TextStyle(fontSize: 16)),
            Text('Last Updated: ${house.formattedLastUpdated}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            // TODO: Display current energy usage/cost summary here
            // TODO: Buttons for Add Reading, Set Limits, View Analytics, Export Data
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => AddReadingScreen(houseId: house.id)),
                // );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Reading functionality coming soon!')),
                );
              },
              child: const Text('Add Energy Reading'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => LimitSettingsScreen(houseId: house.id)),
                // );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Set Limits functionality coming soon!')),
                );
              },
              child: const Text('Set Energy Limits'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => AnalyticsScreen(houseId: house.id)),
                // );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analytics functionality coming soon!')),
                );
              },
              child: const Text('View Analytics'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ExportScreen(houseId: house.id)),
                // );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export Data functionality coming soon!')),
                );
              },
              child: const Text('Export Data'),
            ),
          ],
        ),
      ),
    );
  }
}
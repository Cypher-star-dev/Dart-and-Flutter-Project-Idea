// lib/screens/house_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:energy_monitor/models/house.dart';
import 'package:energy_monitor/models/energy_reading.dart'; // Import EnergyReading
import 'package:energy_monitor/models/energy_source.dart';
import 'package:energy_monitor/providers/house_provider.dart';
import 'package:energy_monitor/providers/reading_provider.dart'; // Import ReadingProvider
import 'package:energy_monitor/screens/add_reading_screen.dart';
// import 'package:energy_monitor/screens/limit_settings_screen.dart';
// import 'package:energy_monitor/screens/analytics_screen.dart';
// import 'package:energy_monitor/screens/export_screen.dart';

class HouseDetailScreen extends StatelessWidget {
  final String houseId;
  const HouseDetailScreen({super.key, required this.houseId});

  @override
  Widget build(BuildContext context) {
    // We listen to HouseProvider to get the house details
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
                // HouseProvider's deleteHouse method also handles deleting associated readings, limits, etc.
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

            // Display current energy usage/cost summary for the house
            const Text(
              'Current Period Usage:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Cost: \$${house.currentBalance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                Text('Total kWh: ${house.currentKWhConsumption.toStringAsFixed(2)} kWh', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddReadingScreen(houseId: house.id)),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Energy Reading'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => LimitSettingsScreen(houseId: house.id)),
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Set Limits functionality coming soon!')),
                  );
                },
                icon: const Icon(Icons.speed),
                label: const Text('Set Energy Limits'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => AnalyticsScreen(houseId: house.id)),
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Analytics functionality coming soon!')),
                  );
                },
                icon: const Icon(Icons.analytics),
                label: const Text('View Analytics'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ExportScreen(houseId: house.id)),
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export Data functionality coming soon!')),
                  );
                },
                icon: const Icon(Icons.file_download),
                label: const Text('Export Data'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Recent Readings:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<ReadingProvider>(
                builder: (context, readingProvider, child) {
                  final readings = readingProvider.getReadingsForHouse(house.id);
                  if (readings.isEmpty) {
                    return const Center(child: Text('No readings recorded yet.'));
                  }
                  // Sort readings by timestamp in descending order (most recent first)
                  readings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
                  return ListView.builder(
                    itemCount: readings.length,
                    itemBuilder: (context, index) {
                      final reading = readings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text('${reading.kwhUsed.toStringAsFixed(2)} kWh - \$${reading.costPaid.toStringAsFixed(2)}'),
                          subtitle: Text(
                            '${reading.source.toDisplayString()} - ${reading.formattedTimestamp}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final bool? confirmDelete = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete Reading'),
                                    content: const Text('Are you sure you want to delete this energy reading?'),
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
                                await readingProvider.deleteEnergyReading(reading.id, house.id);
                              }
                            },
                          ),
                          onTap: () {
                            // TODO: Implement editing of reading if needed
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tap to edit reading functionality coming soon!')),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
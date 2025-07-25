// lib/widgets/house_card.dart

import 'package:flutter/material.dart';
import 'package:energy_monitor/models/house.dart';

class HouseCard extends StatelessWidget {
  final House house;
  final VoidCallback onTap;

  const HouseCard({
    super.key,
    required this.house,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                house.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                house.address.isNotEmpty ? house.address : 'No address provided',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Last Updated: ${house.formattedLastUpdated}',
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              // TODO: Add quick overview of current energy usage/limit progress here
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Current Balance: \$${house.currentBalance.toStringAsFixed(2)}'),
                  Text('Current kWh: ${house.currentKWhConsumption.toStringAsFixed(2)}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
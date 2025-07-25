// lib/screens/add_reading_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:energy_monitor/models/energy_source.dart';
import 'package:energy_monitor/providers/reading_provider.dart';
import 'package:energy_monitor/utils/validation_helpers.dart'; // Will create this shortly

class AddReadingScreen extends StatefulWidget {
  final String houseId;

  const AddReadingScreen({super.key, required this.houseId});

  @override
  State<AddReadingScreen> createState() => _AddReadingScreenState();
}

class _AddReadingScreenState extends State<AddReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kwhController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  EnergySource _selectedSource = EnergySource.poleElectricity; // Default source

  @override
  void dispose() {
    _kwhController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveReading() async {
    if (_formKey.currentState!.validate()) {
      final kwh = double.parse(_kwhController.text);
      final cost = double.parse(_costController.text);

      // Add the reading using the ReadingProvider
      await Provider.of<ReadingProvider>(context, listen: false).addEnergyReading(
        houseId: widget.houseId,
        timestamp: _selectedDate,
        kwhUsed: kwh,
        costPaid: cost,
        source: _selectedSource,
      );

      // After adding, potentially refresh the house details to show updated stats
      // Or simply pop and let the HouseDetailScreen consumer rebuild
      if (context.mounted) {
        Navigator.pop(context); // Go back to the house detail screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Energy Reading'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _kwhController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'kWh Used',
                  hintText: 'e.g., 150.5',
                  border: OutlineInputBorder(),
                  suffixText: 'kWh',
                ),
                validator: (value) => ValidationHelpers.validateDouble(value, 'kWh used'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cost Paid',
                  hintText: 'e.g., 25.75',
                  border: OutlineInputBorder(),
                  prefixText: '\$', // Placeholder for currency, actual currency can be configurable
                ),
                validator: (value) => ValidationHelpers.validateDouble(value, 'cost paid'),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text('Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<EnergySource>(
                value: _selectedSource,
                decoration: const InputDecoration(
                  labelText: 'Energy Source',
                  border: OutlineInputBorder(),
                ),
                items: EnergySource.values.map((source) {
                  return DropdownMenuItem(
                    value: source,
                    child: Text(source.toDisplayString()),
                  );
                }).toList(),
                onChanged: (source) {
                  if (source != null) {
                    setState(() {
                      _selectedSource = source;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveReading,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Save Reading',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
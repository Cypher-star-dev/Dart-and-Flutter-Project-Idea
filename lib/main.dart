// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:energy_monitor/services/database_service.dart';
import 'package:energy_monitor/providers/house_provider.dart';
import 'package:energy_monitor/providers/reading_provider.dart'; // Import ReadingProvider
import 'package:energy_monitor/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init(); // Initialize the database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HouseProvider()),
        ChangeNotifierProvider(create: (_) => ReadingProvider()), // Add ReadingProvider here
        // Add other providers here later: SettingsProvider, NotificationProvider, LimitProvider, RateTierProvider
      ],
      child: MaterialApp(
        title: 'Energy Monitor',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
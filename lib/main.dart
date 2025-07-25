// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:energy_monitor/services/database_service.dart';
import 'package:energy_monitor/providers/house_provider.dart';
import 'package:energy_monitor/screens/home_screen.dart'; // We'll create this next

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
        // Add other providers here later: ReadingProvider, SettingsProvider, NotificationProvider
      ],
      child: MaterialApp(
        title: 'Energy Monitor',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(), // Our main entry point screen
      ),
    );
  }
}
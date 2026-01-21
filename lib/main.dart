import 'package:flutter/material.dart';

import 'package:flussie/UI/vehicule_list.dart';

// Tessie API documentation: https://developer.tessie.com/reference/about

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: VehiculeList(),
    );
  }
}

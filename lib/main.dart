import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flussie/misc/messages.dart';
import 'package:flussie/providers/providers.dart';
import 'package:flussie/views/vehicle_list_view.dart';

// Tessie API documentation: https://developer.tessie.com/reference/about

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: VehicleListView(
        apiProvider: Providers().apiProvider,
        storageProvider: Providers().storageProvider,
      ),
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
    );
  }
}

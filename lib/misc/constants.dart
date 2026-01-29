import 'package:flutter/material.dart';

class Constants {
  // API related constants
  static const String apiBaseUrl = 'https://api.tessie.com';
  static const String tokenStorageKey = 'token';

  // UI related constants
  static const Color batteryGoodColor = Colors.green;
  static const Color batteryWarningColor = Colors.orange;
  static const Color batteryCriticalColor = Colors.red;

  static const Color chargeTypeSuperchargerColor = Colors.red;
  static const Color chargeTypeFastChargerColor = Colors.blue;
  static const Color chargeTypeStandardChargerColor = Colors.green;

  static const Color darkGreyColor = Color(0xFF555555);
}
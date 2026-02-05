import 'package:flutter/material.dart';

import 'package:flussie/misc/constants.dart';

class BatteryUIService {

  static final BatteryUIService _instance = BatteryUIService._internal();

  BatteryUIService._internal();

  factory BatteryUIService() {
    return _instance;
  }

  (IconData, double, Color) getBatteryIcon(int? batteryLevel, {double size = 25.0}) {
    if (batteryLevel == null) {
      return (Icons.battery_unknown, size, Colors.black);
    }

    // Treat clearly invalid values as alert (keep existing alert behavior)
    if (batteryLevel < 0 || batteryLevel > 100) {
      return (Icons.battery_alert, size, Constants.batteryCriticalColor);
    }

    // Color by ranges: 0-5 red, 6-20 orange, 21-100 green
    final Color color;
    if (batteryLevel <= 5) {
      color = Constants.batteryCriticalColor;
    } else if (batteryLevel <= 20) {
      color = Constants.batteryWarningColor;
    } else {
      color = Constants.batteryGoodColor;
    }

    // Map percentage 0..100 to bar index 0..6
    int bar = ((batteryLevel * 6) / 100).round();
    if (bar < 0) bar = 0;
    if (bar > 6) bar = 6;

    IconData iconData;
    switch (bar) {
      case 0:
        iconData = Icons.battery_0_bar;
        break;
      case 1:
        iconData = Icons.battery_1_bar;
        break;
      case 2:
        iconData = Icons.battery_2_bar;
        break;
      case 3:
        iconData = Icons.battery_3_bar;
        break;
      case 4:
        iconData = Icons.battery_4_bar;
        break;
      case 5:
        iconData = Icons.battery_5_bar;
        break;
      case 6:
      default:
        iconData = Icons.battery_6_bar;
        break;
    }

    return (iconData, size, color);
  }
}
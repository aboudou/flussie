import 'package:flutter/material.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/services/ui_service.dart';

class Battery extends StatelessWidget {

  const Battery(
    {
      super.key,
      this.level = 100,
      this.size = 25.0
    }
  );

  final int level;
  final double size;
  
  @override
  Widget build(BuildContext context) {
    return UIService().rotatedIcon(
      Icon(
        _getBatteryIcon(level, size: size).$1, 
        size: _getBatteryIcon(level, size: size).$2, 
        color: _getBatteryIcon(level, size: size).$3
      ),
      90, 
      size: size
    );
  }

  (IconData, double, Color) _getBatteryIcon(int? level, {double size = 25.0}) {
    if (level == null) {
      return (Icons.battery_unknown, size, Colors.black);
    }

    // Treat clearly invalid values as alert (keep existing alert behavior)
    if (level < 0 || level > 100) {
      return (Icons.battery_alert, size, Constants.batteryCriticalColor);
    }

    // Color by ranges: 0-5 red, 6-20 orange, 21-100 green
    final Color color;
    if (level <= 5) {
      color = Constants.batteryCriticalColor;
    } else if (level <= 20) {
      color = Constants.batteryWarningColor;
    } else {
      color = Constants.batteryGoodColor;
    }

    // Map percentage 0..100 to bar index 0..6
    int bar = ((level * 6) / 100).round();
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

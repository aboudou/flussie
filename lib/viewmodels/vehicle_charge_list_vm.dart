import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/models/charge.dart';
import 'package:flussie/providers/api_provider.dart';
import 'package:flussie/services/battery_service.dart';
import 'package:flussie/services/image_service.dart';

class VehicleChargeListViewModel {
    VehicleChargeListViewModel({required this.vin}) {
    refresh();
  }

  static const _dateFormatCurrentYear = 'EEE dd MMM, HH:mm';
  static const _dateFormatPreviousYear = 'dd MMM yyyy, HH:mm';

    final ApiProvider _api = ApiProvider();
    final String vin;

  late Rx<ChargeList> chargeList = ChargeList(results: []).obs;
  RxString errorMessage = ''.obs;
  bool superchargersOnly = false;
  int startDate = (DateTime.now().subtract(Duration(days: 365)).millisecondsSinceEpoch) ~/ 1000;
  int endDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  RxBool showFilters = false.obs;

  void refresh() {
    errorMessage.value = '';

    _api.getCharges(vin, superchargersOnly, startDate, endDate).then((value) {
      chargeList.value = value;
    }).catchError((error) {
      errorMessage.value = error.toString();
    });
  }

  Color getChargeTypeColor(Charge charge) {
    if (charge.isSupercharger == true) {
      return Constants.chargeTypeSuperchargerColor;
    } else if (charge.isFastCharger == true) {
      return Constants.chargeTypeFastChargerColor ;
    } else {
      return Constants.chargeTypeStandardChargerColor;
    }
  }

  String getChargeLocation(Charge charge) {
    return (charge.savedLocation?.isEmpty ?? true) ? (charge.location ?? "Unknown location") : charge.savedLocation ?? "Unknown location";
  }
  
  String getStartBatteryLevel(Charge charge) {
    return '${charge.startingBattery ?? 0} %';
  }

  String getEndBatteryLevel(Charge charge) {
    return '${charge.endingBattery ?? 0} %';
  }

  Container getStartBatteryIcon(Charge charge, double size) {
    final batteryLevel = charge.startingBattery ?? 0;
    final batteryData = BatteryService().getBatteryIcon(batteryLevel, size: size);
    final icon = Icon(batteryData.$1, size: batteryData.$2, color: batteryData.$3);
    return ImageService().rotatedIcon(icon, 90, size: size);
  }

  Container getEndBatteryIcon(Charge charge, double size) {
    final batteryLevel = charge.endingBattery ?? 0;
    final batteryData = BatteryService().getBatteryIcon(batteryLevel, size: size);
    final icon = Icon(batteryData.$1, size: batteryData.$2, color: batteryData.$3);
    return ImageService().rotatedIcon(icon, 90, size: size);
  }

  String getStartDate(Charge charge) {
    final startDate = DateTime.fromMillisecondsSinceEpoch((charge.startedAt ?? 0) * 1000);
    if (startDate.year == DateTime.now().year) {
      return DateFormat(_dateFormatCurrentYear).format(startDate);
    } else {
      return DateFormat(_dateFormatPreviousYear).format(startDate);
    }
  }

  String getEndDate(Charge charge) {
    final endDate = DateTime.fromMillisecondsSinceEpoch((charge.endedAt ?? 0) * 1000);
    if (endDate.year == DateTime.now().year) {
      return DateFormat(_dateFormatCurrentYear).format(endDate);
    } else {
      return DateFormat(_dateFormatPreviousYear).format(endDate);
    }
  }

  String getCost(Charge charge) {
    return charge.cost != null ? '${charge.cost?.toStringAsFixed(2)} €' : 'N/A';
  }

  String getEnergyAdded(Charge charge) {
    return charge.energyAdded != null ? '${charge.energyAdded?.toStringAsFixed(0)} kWh' : 'N/A';
  }

  String getDuration(Charge charge) {
    final startDate = DateTime.fromMillisecondsSinceEpoch((charge.startedAt ?? 0) * 1000);
    final endDate = DateTime.fromMillisecondsSinceEpoch((charge.endedAt ?? 0) * 1000);
    final duration = Duration(seconds: endDate.difference(startDate).inSeconds);
    return [
      if (duration.inHours > 0) '${duration.inHours}h',
      if (duration.inMinutes.remainder(60) > 0) '${duration.inMinutes.remainder(60)}m',
    ].join(' ');
  }

}
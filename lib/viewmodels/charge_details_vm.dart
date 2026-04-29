import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:flussie/enums/charge_type.dart';
import 'package:flussie/models/charge.dart';

class ChargeDetailsViewModel {
  ChargeDetailsViewModel({required this.charge}) {
    initializeDateFormatting();
    _initViewModel();
  }

  final Charge charge;
  
  final Locale locale = Get.deviceLocale ?? Locale('en', 'US');

  LatLng coordinates = LatLng(0, 0);
  ChargeType stationType = ChargeType.standardCharger;

  String location = '';

  int startingBattery = 0;
  String startBatteryLevel = '';
  String startBatteryDate = '';

  int endingBattery = 0;
  String endBatteryLevel = '';
  String endBatteryDate = '';

  String odometer = '';
  String distanceSinceLastCharge = '';

  String energyUsed = '';
  String energyAdded = '';
  String efficiency = '';

  String cost = '';

  void _initViewModel() async {
    if (charge.latitude != null && charge.longitude != null) {
      coordinates = LatLng(charge.latitude!, charge.longitude!);
    }

    if (charge.isSupercharger == true) {
      stationType = ChargeType.supercharger;
    } else if (charge.isFastCharger == true) {
      stationType = ChargeType.fastCharger;
    } else {
      stationType = ChargeType.standardCharger;
    }

    location = (charge.savedLocation?.isEmpty ?? true) ? (charge.location ?? "error_unknown_location".tr) : charge.savedLocation ?? "error_unknown_location".tr;

    startingBattery = charge.startingBattery ?? 0;
    startBatteryLevel = '$startingBattery%';
    if (charge.startedAt != null) {
      final DateTime startDateTime = DateTime.fromMillisecondsSinceEpoch(charge.startedAt! * 1000);
      final Locale locale = Get.deviceLocale ?? Locale('en', 'US');
      final String dateFormat = startDateTime.year == DateTime.now().year ? 'EEE dd MMM, HH:mm' : 'dd MMM yyyy, HH:mm';
      startBatteryDate = DateFormat(dateFormat, locale.toString()).format(startDateTime);
    }

    endingBattery = charge.endingBattery ?? 0;
    endBatteryLevel = '$endingBattery%';
    if (charge.endedAt != null) {
      final DateTime endDateTime = DateTime.fromMillisecondsSinceEpoch(charge.endedAt! * 1000);
      final Locale locale = Get.deviceLocale ?? Locale('en', 'US');
      final String dateFormat = endDateTime.year == DateTime.now().year ? 'EEE dd MMM, HH:mm' : 'dd MMM yyyy, HH:mm';
      endBatteryDate = DateFormat(dateFormat, locale.toString()).format(endDateTime);
    }

    odometer = _distanceFormatter(charge.odometer);
    distanceSinceLastCharge = _distanceFormatter(charge.sinceLastCharge);

    energyUsed = _energyFormatter(charge.energyUsed);
    energyAdded = _energyFormatter(charge.energyAdded);
    efficiency = (charge.energyUsed != null && charge.energyUsed != 0) ? '${NumberFormat("#,##0.00", locale.toString()).format(((charge.energyAdded ?? 0) / (charge.energyUsed ?? 1)) * 100)} %' : 'N/A';

    cost = _costFormatter(charge.cost);
  }

  String _distanceFormatter(double? distance) {
    return distance != null ? '${NumberFormat("#,##0.00", locale.toString()).format(distance)} km' : 'N/A';
  }

  String _energyFormatter(double? energy) {
    return energy != null ? '${NumberFormat("#,##0.00", locale.toString()).format(energy)} kWh' : 'N/A';
  }

  String _costFormatter(double? cost) {
    return cost != null ? '${NumberFormat("#,##0.00", locale.toString()).format(cost)} €' : 'N/A';
  }
}
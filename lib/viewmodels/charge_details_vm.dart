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

  LatLng coordinates = LatLng(0, 0);
  ChargeType stationType = ChargeType.standardCharger;

  String location = '';

  int startingBattery = 0;
  String startBatteryLevel = '';
  String startBatteryDate = '';

  int endingBattery = 0;
  String endBatteryLevel = '';
  String endBatteryDate = '';

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

    location = (charge.savedLocation?.isEmpty ?? true) ? (charge.location ?? "Unknown location") : charge.savedLocation ?? "Unknown location";

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
  }
}

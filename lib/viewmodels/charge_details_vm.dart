import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:flussie/enums/charge_type.dart';
import 'package:flussie/misc/converters.dart';
import 'package:flussie/models/charge.dart';

class ChargeDetailsViewModel {
  ChargeDetailsViewModel({required this.charge}) {
    _initViewModel();
  }

  final Charge charge;

  final Locale locale = Converters.deviceLocale;

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

  void _initViewModel() {
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
      startBatteryDate = Converters.formatDate(
        DateTime.fromMillisecondsSinceEpoch(charge.startedAt! * 1000),
        locale,
      );
    }

    endingBattery = charge.endingBattery ?? 0;
    endBatteryLevel = '$endingBattery%';
    if (charge.endedAt != null) {
      endBatteryDate = Converters.formatDate(
        DateTime.fromMillisecondsSinceEpoch(charge.endedAt! * 1000),
        locale,
      );
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
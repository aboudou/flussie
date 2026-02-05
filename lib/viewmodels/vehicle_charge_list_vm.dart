import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/models/charge.dart';
import 'package:flussie/providers/api_provider.dart';

class VehicleChargeListViewModel {
    VehicleChargeListViewModel({required this.vin}) {
    initializeDateFormatting();
    refresh();
  }

  static const _dateFormatCurrentYear = 'EEE dd MMM, HH:mm';
  static const _dateFormatPreviousYear = 'dd MMM yyyy, HH:mm';

  final Locale locale = Get.deviceLocale ?? Locale('en', 'US');
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
    return '${charge.startingBattery ?? 0}%';
  }

  String getEndBatteryLevel(Charge charge) {
    return '${charge.endingBattery ?? 0}%';
  }

  String getStartDate(Charge charge) {
    final startDate = DateTime.fromMillisecondsSinceEpoch((charge.startedAt ?? 0) * 1000);
    if (startDate.year == DateTime.now().year) {
      return DateFormat(_dateFormatCurrentYear, locale.toString()).format(startDate);
    } else {
      return DateFormat(_dateFormatPreviousYear, locale.toString()).format(startDate);
    }
  }

  String getEndDate(Charge charge) {
    final endDate = DateTime.fromMillisecondsSinceEpoch((charge.endedAt ?? 0) * 1000);
    if (endDate.year == DateTime.now().year) {
      return DateFormat(_dateFormatCurrentYear, locale.toString()).format(endDate);
    } else {
      return DateFormat(_dateFormatPreviousYear, locale.toString()).format(endDate);
    }
  }

  String getCost(Charge charge) {
    return charge.cost != null ? '${NumberFormat("#,##0.00", locale.toString()).format(charge.cost)} €' : 'N/A';
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
import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flussie/models/drive.dart';
import 'package:flussie/providers/api_provider.dart';

class DriveListViewModel {
    DriveListViewModel({required this.vin}) {
    initializeDateFormatting();
    refresh();
  }

  static const _dateFormatCurrentYear = 'EEE dd MMM, HH:mm';
  static const _dateFormatPreviousYear = 'dd MMM yyyy, HH:mm';

  final Locale locale = Get.deviceLocale ?? Locale('en', 'US');
  final ApiProvider _api = ApiProvider();
  final String vin;

  late Rx<DriveList> driveList = DriveList(results: []).obs;
  RxString errorMessage = ''.obs;
  int startDate = (DateTime.now().subtract(Duration(days: 365)).millisecondsSinceEpoch) ~/ 1000;
  int endDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  RxBool showFilters = false.obs;

  void refresh() {
    errorMessage.value = '';

    _api.getDrives(vin, startDate, endDate).then((value) {
      driveList.value = value;
    }).catchError((error) {
      errorMessage.value = error.toString();
    });
  }

  String getDriveStartLocation(Drive drive) {
    return (drive.startingSavedLocation?.isEmpty ?? true) ? (drive.startingLocation ?? "Unknown location") : drive.startingSavedLocation ?? "Unknown location";
  }
  
  String getStartBatteryLevel(Drive drive) {
    return '${drive.startingBattery ?? 0}%';
  }

  String getDriveEndLocation(Drive drive) {
    return (drive.endingSavedLocation?.isEmpty ?? true) ? (drive.endingLocation ?? "Unknown location") : drive.endingSavedLocation ?? "Unknown location";
  }

  String getEndBatteryLevel(Drive drive) {
    return '${drive.endingBattery ?? 0}%';
  }

  String getStartDate(Drive drive) {
    final startDate = DateTime.fromMillisecondsSinceEpoch((drive.startedAt ?? 0) * 1000);
    if (startDate.year == DateTime.now().year) {
      return DateFormat(_dateFormatCurrentYear, locale.toString()).format(startDate);
    } else {
      return DateFormat(_dateFormatPreviousYear, locale.toString()).format(startDate);
    }
  }

  String getEndDate(Drive drive) {
    final endDate = DateTime.fromMillisecondsSinceEpoch((drive.endedAt ?? 0) * 1000);
    if (endDate.year == DateTime.now().year) {
      return DateFormat(_dateFormatCurrentYear, locale.toString()).format(endDate);
    } else {
      return DateFormat(_dateFormatPreviousYear, locale.toString()).format(endDate);
    }
  }

  String getDriveDuration(Drive drive) {
    if (drive.startedAt != null && drive.endedAt != null) {
      final duration = Duration(seconds: (drive.endedAt! - drive.startedAt!));
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    }
    return 'Unknown duration';
  }

  String getDriveDistance(Drive drive) {
    if (drive.odometerDistance != null) {
      return '${NumberFormat("#,##0.00", locale.toString()).format(drive.odometerDistance!)} km';
    }
    return 'Unknown distance';
  }
}
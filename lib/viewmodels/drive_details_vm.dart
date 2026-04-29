import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:flussie/models/drive.dart';

class DriveDetailsViewModel {
  DriveDetailsViewModel({required this.drive, required this.vin, required this.coordinates}) {
    initializeDateFormatting();
    _initViewModel();
  }

  final Drive drive;
  final String vin;
  final List<LatLng> coordinates;
  final Locale locale = Get.deviceLocale ?? Locale('en', 'US');

  String startLocation = '';
  String endLocation = '';

  String startDriveDate = '';
  String endDriveDate = '';

  String startBatteryLevel = '';
  String endBatteryLevel = '';

  String driveDistance = '';
  String driveDuration = '';

  String energyUsed = '';
  String energyUsedPerKm = '';

  String averageSpeed = '';
  String maxSpeed = '';

  void _initViewModel() async {
    if (drive.startingSavedLocation != null && drive.startingSavedLocation!.isNotEmpty) {
      startLocation = drive.startingSavedLocation!;
    } else if (drive.startingLocation != null && drive.startingLocation!.isNotEmpty) {
      startLocation = drive.startingLocation!;
    } else {
      startLocation = "error_unknown_location".tr;
    }

    if (drive.endingSavedLocation != null && drive.endingSavedLocation!.isNotEmpty) {
      endLocation = drive.endingSavedLocation!;
    } else if (drive.endingLocation != null && drive.endingLocation!.isNotEmpty) {
      endLocation = drive.endingLocation!;
    } else {
      endLocation = "error_unknown_location".tr;
    }

    if (drive.startedAt != null) {
      final startDate = DateTime.fromMillisecondsSinceEpoch(drive.startedAt! * 1000);
      startDriveDate = DateFormat('EEE dd MMM yyyy, HH:mm', locale.toString()).format(startDate);
    }
    if (drive.endedAt != null) {
      final endDate = DateTime.fromMillisecondsSinceEpoch(drive.endedAt! * 1000);
      endDriveDate = DateFormat('EEE dd MMM yyyy, HH:mm', locale.toString()).format(endDate);
    }

    startBatteryLevel = '${drive.startingBattery ?? 0}%';
    endBatteryLevel = '${drive.endingBattery ?? 0}%';

    if (drive.odometerDistance != null) {
      driveDistance = '${(drive.odometerDistance!).toStringAsFixed(2)} km';
    }
    if (drive.startedAt != null && drive.endedAt != null) {
      final duration = Duration(seconds: (drive.endedAt! - drive.startedAt!));
      driveDuration = _formatDuration(duration);
    }
    
    if (drive.energyUsed != null) {
      energyUsed = '${(drive.energyUsed!).toStringAsFixed(2)} kWh';
    }
    if (drive.odometerDistance != null && drive.energyUsed != null && drive.odometerDistance! > 0) {
      energyUsedPerKm = '${(drive.energyUsed! * 1000 / drive.odometerDistance!).toStringAsFixed(0)} Wh/km';
    }

    if (drive.averageSpeed != null) {
      averageSpeed = '${(drive.averageSpeed!).toStringAsFixed(0)} km/h';
    }
    if (drive.maxSpeed != null) {
      maxSpeed = '${(drive.maxSpeed!).toStringAsFixed(0)} km/h';
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
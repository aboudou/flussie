import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flussie/misc/converters.dart';
import 'package:flussie/models/drive.dart';
import 'package:flussie/providers/api/api_provider.dart';
import 'package:latlong2/latlong.dart';

class DriveListViewModel {
  DriveListViewModel({required this.vin, required ApiProvider apiProvider}) : _apiProvider = apiProvider {
    refresh();
  }

  final Locale locale = Converters.deviceLocale;
  final ApiProvider _apiProvider;
  final String vin;

  late Rx<DriveList> driveList = DriveList(results: []).obs;
  RxString errorMessage = ''.obs;
  int startDate = (DateTime.now().subtract(Duration(days: 365)).millisecondsSinceEpoch) ~/ 1000;
  int endDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  RxBool showFilters = false.obs;

  Future<void> refresh() async {
    errorMessage.value = '';
    try {
      driveList.value = await _apiProvider.getDrives(vin, startDate, endDate);
    } catch (error) {
      errorMessage.value = 'error_loading_drives'.trParams({'error': error.toString()});
    }
  }

  String getDriveStartLocation(Drive drive) {
    return (drive.startingSavedLocation?.isEmpty ?? true) ? (drive.startingLocation ?? 'error_unknown_location'.tr) : drive.startingSavedLocation ?? 'error_unknown_location'.tr;
  }
  
  String getStartBatteryLevel(Drive drive) {
    return '${drive.startingBattery ?? 0}%';
  }

  String getDriveEndLocation(Drive drive) {
    return (drive.endingSavedLocation?.isEmpty ?? true) ? (drive.endingLocation ?? 'error_unknown_location'.tr) : drive.endingSavedLocation ?? 'error_unknown_location'.tr;
  }

  String getEndBatteryLevel(Drive drive) {
    return '${drive.endingBattery ?? 0}%';
  }

  String getStartDate(Drive drive) {
    return Converters.formatDate(
      DateTime.fromMillisecondsSinceEpoch((drive.startedAt ?? 0) * 1000),
      locale,
    );
  }

  String getEndDate(Drive drive) {
    return Converters.formatDate(
      DateTime.fromMillisecondsSinceEpoch((drive.endedAt ?? 0) * 1000),
      locale,
    );
  }

  String getDriveDuration(Drive drive) {
    if (drive.startedAt != null && drive.endedAt != null) {
      final duration = Duration(seconds: (drive.endedAt! - drive.startedAt!));
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    }
    return 'error_unknown_duration'.tr;
  }

  String getDriveDistance(Drive drive) {
    if (drive.odometerDistance != null) {
      return '${NumberFormat("#,##0.00", locale.toString()).format(drive.odometerDistance!)} km';
    }
    return 'error_unknown_distance'.tr;
  }

  Future<List<LatLng>> getDriveCoordinates(Drive drive) async {
    if (drive.startedAt != null && drive.endedAt != null) {
      try {
        final path = await _apiProvider.getPath(vin, drive.startedAt!, drive.endedAt!);
        return path.results;
      } catch (error) {
        return <LatLng>[];
      }
    }
    return [];
  }

  void dispose() {
    driveList.close();
    errorMessage.close();
    showFilters.close();
  }
}
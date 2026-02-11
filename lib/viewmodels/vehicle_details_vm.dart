import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:flussie/models/battery_health.dart';
import 'package:flussie/models/vehicle.dart';
import 'package:flussie/providers/api_provider.dart';

class VehicleDetailsViewModel {
  VehicleDetailsViewModel({required this.vin}) {
    refresh();
  }

  final ApiProvider _api = ApiProvider();
  final String vin;

  Rx<LatLng> coordinates = LatLng(0, 0).obs;
  RxDouble heading = 0.0.obs;
  RxString state = ''.obs;
  RxString chargePortState = ''.obs;
  RxString location = ''.obs;
  RxString odometer = ''.obs;
  RxInt batteryLevel = 0.obs;
  RxInt batteryRange = 0.obs;
  RxString remainingEnergy = ''.obs;
  RxString batteryHealth = ''.obs;
  RxString batteryDegradation = ''.obs;

  void refresh() async {
    _api.getVehicle(vin).then((value) async {
      Vehicle vehicle = value;

      coordinates.value = LatLng(vehicle.driveState?.latitude ?? 0.0, vehicle.driveState?.longitude ?? 0.0);
      heading.value = vehicle.driveState?.heading?.toDouble() ?? 0.0;
      
      if (vehicle.chargeState?.chargerActualCurrent != null && vehicle.chargeState?.chargerActualCurrent != 0) {
        state.value = "Charging";

      } else if (vehicle.driveState?.shiftState != null && vehicle.driveState?.shiftState != "P") {
        state.value = "Driving";

      } else {
        switch (vehicle.state) {
          case 'asleep':
            state.value = 'Sleeping';
            break;
          case 'online':
            state.value = 'Parked';
            break;
          default:
            state.value = 'Unknown state';
        }
      }

      final double odomInKm = (vehicle.vehicleState?.odometer ?? 0.0) * 1.60934;
      final Locale locale = Get.deviceLocale ?? Locale('en', 'US');
      odometer.value = '${NumberFormat("#,##0.0", locale.toString()).format(odomInKm)} km';
      
      chargePortState.value = vehicle.chargeState?.chargePortDoorOpen == true ? 'Plugged' : 'Unplugged';

      ApiProvider().getLocation(vin).then((locValue) {
        location.value = locValue.address ?? 'Unknown location';
      });

      batteryLevel.value = vehicle.chargeState?.batteryLevel ?? 0;
      batteryRange.value = ((vehicle.chargeState?.batteryRange ?? 0.0) * 1.60934).round();
      remainingEnergy.value = vehicle.chargeState?.energyRemaining != null ? '${NumberFormat("#,##0.00", locale.toString()).format(vehicle.chargeState?.energyRemaining)} kWh' : 'N/A';

      ApiProvider().getBatteryHealth().then((batteryHealthValue) {
        final BatteryHealth? batteryHealthResult = batteryHealthValue.results?.firstWhere(
          (element) => element.vin == vin,
        );
        batteryHealth.value = batteryHealthResult?.healthPercent != null ? '${NumberFormat("#,##0.00", locale.toString()).format(batteryHealthResult?.healthPercent)}%' : 'N/A';
        batteryDegradation.value = batteryHealthResult?.degradationPercent != null ? '${NumberFormat("#,##0.00", locale.toString()).format(batteryHealthResult?.degradationPercent)}%' : 'N/A';
      });
    });
  }
}
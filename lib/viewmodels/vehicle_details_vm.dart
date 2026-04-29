import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:flussie/models/battery_health.dart';
import 'package:flussie/misc/converters.dart';
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
        state.value = 'vehicle_state_charging'.tr;

      } else if (vehicle.driveState?.shiftState != null && vehicle.driveState?.shiftState != "P") {
        state.value = 'vehicle_state_driving'.tr;

      } else {
        switch (vehicle.state) {
          case 'asleep':
            state.value = 'vehicle_state_sleeping'.tr;
            break;
          case 'online':
            state.value = 'vehicle_state_parked'.tr;
            break;
          default:
            state.value = 'error_unknown_vehicle_state'.tr;
        }
      }

      final double odomInKm = Converters.milesToKm(vehicle.vehicleState?.odometer);
      final Locale locale = Get.deviceLocale ?? Locale('en', 'US');
      odometer.value = '${NumberFormat("#,##0.0", locale.toString()).format(odomInKm)} km';
      
      chargePortState.value = vehicle.chargeState?.chargePortDoorOpen == true ? 'vehicle_charge_port_plugged'.tr : 'vehicle_charge_port_unplugged'.tr;

      ApiProvider().getLocation(vin).then((locValue) {
        location.value = locValue.address ?? 'error_unknown_location'.tr;
      });

      batteryLevel.value = vehicle.chargeState?.batteryLevel ?? 0;
      batteryRange.value = Converters.milesToKm(vehicle.chargeState?.batteryRange).round();
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
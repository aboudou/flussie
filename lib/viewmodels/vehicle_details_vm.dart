import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:flussie/models/battery_health.dart';
import 'package:flussie/misc/converters.dart';
import 'package:flussie/providers/api/api_provider.dart';

class VehicleDetailsViewModel {
  VehicleDetailsViewModel({required this.vin, required ApiProvider apiProvider}) : _apiProvider = apiProvider {
    refresh();
  }

  final ApiProvider _apiProvider;
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

  Future<void> refresh() async {
    try {
      final locale = Get.deviceLocale ?? Locale('en', 'US');

      // All three calls are independent — start them in parallel
      final vehicleFuture = _apiProvider.getVehicle(vin);
      final locationFuture = _apiProvider.getLocation(vin);
      final batteryHealthFuture = _apiProvider.getBatteryHealth();

      final vehicle = await vehicleFuture;

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

      odometer.value = '${NumberFormat("#,##0.0", locale.toString()).format(Converters.milesToKm(vehicle.vehicleState?.odometer))} km';
      chargePortState.value = vehicle.chargeState?.chargePortDoorOpen == true
          ? 'vehicle_charge_port_plugged'.tr
          : 'vehicle_charge_port_unplugged'.tr;
      batteryLevel.value = vehicle.chargeState?.batteryLevel ?? 0;
      batteryRange.value = Converters.milesToKm(vehicle.chargeState?.batteryRange).round();
      remainingEnergy.value = vehicle.chargeState?.energyRemaining != null
          ? '${NumberFormat("#,##0.00", locale.toString()).format(vehicle.chargeState?.energyRemaining)} kWh'
          : 'N/A';

      final locValue = await locationFuture;
      location.value = locValue.address ?? 'error_unknown_location'.tr;

      final batteryHealthValue = await batteryHealthFuture;
      final BatteryHealth? batteryHealthResult = batteryHealthValue.results?.firstWhere(
        (element) => element.vin == vin,
      );
      batteryHealth.value = batteryHealthResult?.healthPercent != null
          ? '${NumberFormat("#,##0.00", locale.toString()).format(batteryHealthResult?.healthPercent)}%'
          : 'N/A';
      batteryDegradation.value = batteryHealthResult?.degradationPercent != null
          ? '${NumberFormat("#,##0.00", locale.toString()).format(batteryHealthResult?.degradationPercent)}%'
          : 'N/A';
    } catch (_) {}
  }

  void dispose() {
    coordinates.close();
    heading.close();
    state.close();
    chargePortState.close();
    location.close();
    odometer.close();
    batteryLevel.close();
    batteryRange.close();
    remainingEnergy.close();
    batteryHealth.close();
    batteryDegradation.close();
  }
}
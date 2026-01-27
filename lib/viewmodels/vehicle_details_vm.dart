import 'dart:convert';

import 'package:get/get.dart';

import 'package:flutter/material.dart';

import 'package:flussie/models/vehicle.dart';
import 'package:flussie/providers/api_provider.dart';

class VehicleDetailsViewModel {
  VehicleDetailsViewModel({required this.vin}) {
    refresh();
  }

  final ApiProvider _api = ApiProvider();
  final String vin;

  late Rx<Image> mapImage = Image.memory(Base64Codec().decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7")).obs; // Blank image placeholder
  late RxString state = ''.obs;
  late RxString chargePortState = ''.obs;
  late RxString location = ''.obs;
  late RxInt batteryLevel = 0.obs;
  late RxDouble batteryRange = 0.0.obs;
  late RxDouble batteryRangeIdeal = 0.0.obs;
  late RxDouble remainingEnergy = 0.0.obs;

  void refresh() {
    ApiProvider().getVehicle(vin).then((value) {
      Vehicle vehicle = value;

      mapImage.value = _api.getMapImage(vin, width: 500, height: 200, zoom: 16);
      
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
      
      chargePortState.value = vehicle.chargeState?.chargePortLatch == 'Engaged' ? 'Plugged' : 'Unplugged';

      ApiProvider().getLocation(vin).then((locValue) {
        location.value = locValue.address ?? 'Unknown location';
      });

      batteryLevel.value = vehicle.chargeState?.batteryLevel ?? 0;
      batteryRange.value = vehicle.chargeState?.batteryRange ?? 0.0;
      batteryRangeIdeal.value = vehicle.chargeState?.idealBatteryRange ?? 0.0;
      remainingEnergy.value = vehicle.chargeState?.energyRemaining ?? 0.0;

    });
  }
}
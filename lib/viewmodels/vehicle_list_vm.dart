import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flussie/models/location.dart';
import 'package:flussie/models/vehicles.dart';
import 'package:flussie/providers/api_provider.dart';
import 'package:flussie/providers/storage_provider.dart';

class VehiculeListViewModel {
  final StorageProvider _storageProvider = StorageProvider();
  final ApiProvider _api = ApiProvider();

  // Observables
  RxString token = ''.obs;
  RxList<VehicleListItem> vehicles = <VehicleListItem>[].obs;
  RxString location = 'Loading address…'.obs;
  Rx<Image> mapImage = Image.asset('').obs;
  RxString errorMessage = ''.obs;

  // Vehicles management
  void refreshVehiclesList() async {
    try {
      vehicles.value = await _api.getVehicles() ?? [];
      errorMessage.value = '';
    } catch (e) {
      vehicles.clear();
      errorMessage.value = 'Error loading vehicles: $e';
    }
  }

  void refreshVehicle(String vin) {
    refreshLocation(vin);
    refreshMapImage(vin);
  }

  void refreshLocation(String vin) async {
    Location locationObj = await _api.getLocation(vin);
    if (locationObj.address?.isNotEmpty ?? false) {
      location.value = locationObj.address!;
    } else {
      location.value = 'No address found';
    }
  }

  void refreshMapImage(String vin) {
    mapImage.value = _api.getMapImage(vin);
  }

  // Token management
  void getToken() {
    token.value = _storageProvider.getToken() ?? '';
  }

  Future<void> deleteToken() async {
    await _storageProvider.deleteToken();
    vehicles.clear();
    token.value = '';
    errorMessage.value = '';
  }

  Function? addListener(Function() callback) {
    return _storageProvider.addListener(callback);
  }

  void listenToken(Function(dynamic) callback) {
    _storageProvider.listenToken(callback);
  }

}
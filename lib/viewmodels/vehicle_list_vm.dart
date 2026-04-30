import 'dart:typed_data';

import 'package:get/get.dart';

import 'package:flussie/models/location.dart';
import 'package:flussie/models/vehicles.dart';
import 'package:flussie/providers/api/api_provider.dart';
import 'package:flussie/providers/storage/storage_provider.dart';

class VehicleListViewModel {
  VehicleListViewModel({required StorageProvider storageProvider, required ApiProvider apiProvider})
      : _storageProvider = storageProvider,
        _apiProvider = apiProvider;

  final StorageProvider _storageProvider;
  final ApiProvider _apiProvider;

  // Observables
  RxBool isLoggedIn = false.obs;
  RxString token = ''.obs;
  RxList<VehicleListItem> vehicles = <VehicleListItem>[].obs;
  RxString location = 'Loading address…'.obs;
  Rx<Uint8List> mapImageBytes = Uint8List(0).obs;
  RxString errorMessage = ''.obs;

  // Vehicles management
  void refreshVehiclesList() async {
    try {
      vehicles.value = await _apiProvider.getVehicles() ?? [];
      errorMessage.value = '';
    } catch (e) {
      vehicles.clear();
      errorMessage.value = 'error_loading_vehicles'.trParams({'error': e.toString()});
    }
  }

  void refreshVehicle(String vin) {
    refreshLocation(vin);
    refreshMapImage(vin);
  }

  void refreshLocation(String vin) async {
    Location locationObj = await _apiProvider.getLocation(vin);
    if (locationObj.address?.isNotEmpty ?? false) {
      location.value = locationObj.address!;
    } else {
      location.value = 'error_unknown_location'.tr;
    }
  }

  void refreshMapImage(String vin) async {
    mapImageBytes.value = await _apiProvider.getMapImage(vin);
  }

  // Token management
  void getToken() async {
    token.value = await _storageProvider.getToken() ?? '';
    isLoggedIn.value = token.value.isNotEmpty;
  }

  Future<void> deleteToken() async {
    isLoggedIn.value = false;
    await _storageProvider.deleteToken();
    vehicles.clear();
    token.value = '';
    errorMessage.value = '';
  }
}
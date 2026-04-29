import 'dart:typed_data';

import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:get/get.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/models/battery_health.dart';
import 'package:flussie/models/charge.dart';
import 'package:flussie/models/drive.dart';
import 'package:flussie/models/location.dart';
import 'package:flussie/models/path.dart';
import 'package:flussie/models/vehicle.dart';
import 'package:flussie/models/vehicles.dart';
import 'package:flussie/providers/binary_local_provider.dart';
import 'package:flussie/providers/binary_network_provider.dart';
import 'package:flussie/providers/json_local_provider.dart';
import 'package:flussie/providers/json_network_provider.dart';

class ApiProvider {

  static final ApiProvider _instance = ApiProvider._internal();

  ApiProvider._internal();

  factory ApiProvider() {
    return _instance;
  }

  // Providers for the real API
  final JsonNetworkProvider _jsonNetworkProvider = JsonNetworkProvider();
  final BinaryNetworkProvider _binaryNetworkProvider = BinaryNetworkProvider();

  // Providers for local JSON files for demo mode
  final JsonLocalProvider _jsonLocalProvider = JsonLocalProvider();
  final BinaryLocalProvider _binaryLocalProvider = BinaryLocalProvider();

  Future<bool> get isDemo async => (await FlutterKeychain.get(key: Constants.tokenStorageKey) == 'demo');

  Future<List<VehicleListItem>?> getVehicles() async {
    final response = await (await isDemo ? _jsonLocalProvider.fetchVehicles() : _jsonNetworkProvider.fetchVehicles());

    if (response.status.hasError) {
      throw Exception('provider_error_vehicles'.trParams({'error': response.statusText ?? ''}));
    }

    return VehicleList.fromJson(response.body as Map<String, dynamic>).vehicles;
  }

  Future<Uint8List> getMapImage(String vin, {int width = 100, int height = 100, int zoom = 13}) async {
    return await (await isDemo ? _binaryLocalProvider.fetchMap() : _binaryNetworkProvider.fetchMap(vin, width: width, height: height, zoom: zoom));
  }

  Future<Vehicle> getVehicle(String vin) async {
    final response = await (await isDemo ? _jsonLocalProvider.fetchVehicle() : _jsonNetworkProvider.fetchVehicle(vin));

    if (response.status.hasError) {
      throw Exception('provider_error_vehicle'.trParams({'error': response.statusText ?? ''}));
    }

    return Vehicle.fromJson(response.body as Map<String, dynamic>);
  }
  
  Future<Location> getLocation(String vin) async {
    final response = await (await isDemo ? _jsonLocalProvider.fetchLocation() : _jsonNetworkProvider.fetchLocation(vin));

    if (response.status.hasError) {
      throw Exception('provider_error_location'.trParams({'error': response.statusText ?? ''}));
    }

    return Location.fromJson(response.body as Map<String, dynamic>);
  }

  Future<BatteryHealthList> getBatteryHealth() async {
    final response = await (await isDemo ? _jsonLocalProvider.fetchBatteryHealth() : _jsonNetworkProvider.fetchBatteryHealth());

    if (response.status.hasError) {
      throw Exception('provider_error_battery_health'.trParams({'error': response.statusText ?? ''}));
    }

    return BatteryHealthList.fromJson(response.body as Map<String, dynamic>);
  }

  Future<ChargeList> getCharges(String vin, bool superchargersOnly, int startDate, int endDate) async {
    final response = await (await isDemo ? _jsonLocalProvider.fetchCharges(superchargersOnly) : _jsonNetworkProvider.fetchCharges(vin, superchargersOnly, startDate, endDate));

    if (response.status.hasError) {
      throw Exception('provider_error_charges'.trParams({'error': response.statusText ?? ''}));
    }

    return ChargeList.fromJson(response.body as Map<String, dynamic>);
  }

  Future<DriveList> getDrives(String vin, int startDate, int endDate) async {
    final response = await (await isDemo ? _jsonLocalProvider.fetchDrives() : _jsonNetworkProvider.fetchDrives(vin, startDate, endDate));

    if (response.status.hasError) {
      throw Exception('provider_error_drives'.trParams({'error': response.statusText ?? ''}));
    }

    return DriveList.fromJson(response.body as Map<String, dynamic>);
  }

  Future<Path> getPath(String vin, int startDate, int endDate) async {
    final response = await (await isDemo ? _jsonLocalProvider.fetchPath(startDate) : _jsonNetworkProvider.fetchPath(vin, startDate, endDate));

    if (response.status.hasError) {
      throw Exception('provider_error_path'.trParams({'error': response.statusText ?? ''}));
    }

    return Path.fromJson(response.body as Map<String, dynamic>);
  }
}
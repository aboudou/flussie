import 'dart:typed_data';

import 'package:get_storage/get_storage.dart';

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

  final JsonNetworkProvider _jsonNetworkProvider = JsonNetworkProvider();
  final BinaryNetworkProvider _binaryNetworkProvider = BinaryNetworkProvider();

  final JsonLocalProvider _jsonLocalProvider = JsonLocalProvider();
  final BinaryLocalProvider _binaryLocalProvider = BinaryLocalProvider();

  bool get isDemo => (GetStorage().read(Constants.tokenStorageKey) == 'demo');

  Future<List<VehicleListItem>?> getVehicles() async {
    final response = isDemo ? await _jsonLocalProvider.fetchVehicles() : await _jsonNetworkProvider.fetchVehicles();

    if (response.status.hasError) {
      throw Exception('Failed to load vehicles: ${response.statusText}');
    }

    return VehicleList.fromJson(response.body as Map<String, dynamic>).vehicles;
  }

  Future<Uint8List> getMapImage(String vin, {int width = 100, int height = 100, int zoom = 13}) async {
    return isDemo ? await _binaryLocalProvider.fetchMap() : await _binaryNetworkProvider.fetchMap(vin, width: width, height: height, zoom: zoom);
  }

  Future<Vehicle> getVehicle(String vin) async {
    final response = isDemo ? await _jsonLocalProvider.fetchVehicle() : await _jsonNetworkProvider.fetchVehicle(vin);

    if (response.status.hasError) {
      throw Exception('Failed to load vehicle $vin: ${response.statusText}');
    }

    return Vehicle.fromJson(response.body as Map<String, dynamic>);
  }
  
  Future<Location> getLocation(String vin) async {
    final response = isDemo ? await _jsonLocalProvider.fetchLocation() : await _jsonNetworkProvider.fetchLocation(vin);

    if (response.status.hasError) {
      throw Exception('Failed to load location for $vin: ${response.statusText}');
    }

    return Location.fromJson(response.body as Map<String, dynamic>);
  }

  Future<BatteryHealthList> getBatteryHealth() async {
    final response = isDemo ? await _jsonLocalProvider.fetchBatteryHealth() : await _jsonNetworkProvider.fetchBatteryHealth();

    if (response.status.hasError) {
      throw Exception('Failed to load battery health: ${response.statusText}');
    }

    return BatteryHealthList.fromJson(response.body as Map<String, dynamic>);
  }

  Future<ChargeList> getCharges(String vin, bool superchargersOnly, int startDate, int endDate) async {
    final response = isDemo ? await _jsonLocalProvider.fetchCharges(superchargersOnly) : await _jsonNetworkProvider.fetchCharges(vin, superchargersOnly, startDate, endDate);

    if (response.status.hasError) {
      throw Exception('Failed to load charges for $vin: ${response.statusText}');
    }

    return ChargeList.fromJson(response.body as Map<String, dynamic>);
  }

  Future<DriveList> getDrives(String vin, int startDate, int endDate) async {
    final response = isDemo ? await _jsonLocalProvider.fetchDrives() : await _jsonNetworkProvider.fetchDrives(vin, startDate, endDate);

    if (response.status.hasError) {
      throw Exception('Failed to load drives for $vin: ${response.statusText}');
    }

    return DriveList.fromJson(response.body as Map<String, dynamic>);
  }

  Future<Path> getPath(String vin, int startDate, int endDate) async {
    final response = isDemo ? await _jsonLocalProvider.fetchPath(startDate) : await _jsonNetworkProvider.fetchPath(vin, startDate, endDate);

    if (response.status.hasError) {
      throw Exception('Failed to load path for $vin: ${response.statusText}');
    }

    return Path.fromJson(response.body as Map<String, dynamic>);
  }
}
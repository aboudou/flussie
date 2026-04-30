import 'package:flussie/providers/json/json_provider.dart';
import 'package:get/get.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

import 'package:flussie/misc/constants.dart';

class JsonNetworkProvider extends GetConnect implements JsonProvider {
  static final JsonNetworkProvider _instance = JsonNetworkProvider._internal();

  JsonNetworkProvider._internal() {
    _clientSetup();
  }

  factory JsonNetworkProvider() {
    return _instance;
  }

  void _clientSetup() {
    httpClient.baseUrl = Constants.apiBaseUrl;

    httpClient.addRequestModifier<Object?>((request) async {
      final token = await FlutterKeychain.get(key: Constants.tokenStorageKey) ?? '';
      request.headers['Authorization'] = "Bearer $token";
      return request;
    });
  }

  @override
  Future<Response> fetchVehicles() {
    return get('/vehicles');
  }

  @override
  Future<Response> fetchVehicle(String vin) {
    return get('/$vin/state');
  }

  @override
  Future<Response> fetchLocation(String vin) {
    return get('/$vin/location');
  }

  @override
  Future<Response> fetchBatteryHealth() {
    return get('/battery_health?distance_format=km');
  }

  @override
  Future<Response> fetchCharges(String vin, bool superchargersOnly, int startDate, int endDate) {
    return get('/$vin/charges?distance_format=km&format=json&timezone=UTC&superchargers_only=$superchargersOnly&from=${startDate.toString()}&to=${endDate.toString()}');
  }

  @override
  Future<Response> fetchDrives(String vin, int startDate, int endDate) {
    return get('/$vin/drives?distance_format=km&format=json&timezone=UTC&from=${startDate.toString()}&to=${endDate.toString()}');
  }

  @override
 Future<Response> fetchPath(String vin, int startDate, int endDate) {
    return get('/$vin/path?from=${startDate.toString()}&to=${endDate.toString()}&simplify=true');
  }
}
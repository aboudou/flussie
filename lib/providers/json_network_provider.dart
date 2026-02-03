import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flussie/misc/constants.dart';

class JsonNetworkProvider extends GetConnect {
  static final JsonNetworkProvider _instance = JsonNetworkProvider._internal();

  JsonNetworkProvider._internal() {
    _clientSetup();
  }

  factory JsonNetworkProvider() {
    return _instance;
  }

  void _clientSetup() {
    httpClient.baseUrl = Constants.apiBaseUrl;

    httpClient.addRequestModifier<Object?>((request) {
      final token = GetStorage().read(Constants.tokenStorageKey) ?? '';
      request.headers['Authorization'] = "Bearer $token";
      return request;
    });
  }

  Future<Response> fetchVehicles() {
    return get('/vehicles');
  }

  Future<Response> fetchVehicle(String vin) {
    return get('/$vin/state');
  }

  Future<Response> fetchLocation(String vin) {
    return get('/$vin/location');
  }

  Future<Response> fetchBatteryHealth() {
    return get('/battery_health?distance_format=km');
  }

  Future<Response> fetchCharges(String vin, bool superchargersOnly, int startDate, int endDate) {
    return get('/$vin/charges?distance_format=km&format=json&timezone=UTC&superchargers_only=$superchargersOnly&from=${startDate.toString()}&to=${endDate.toString()}');
  }
}
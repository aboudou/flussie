import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flussie/misc/constants.dart';

class NetworkProvider extends GetConnect {
  static final NetworkProvider _instance = NetworkProvider._internal();

  NetworkProvider._internal() {
    _clientSetup();
  }

  factory NetworkProvider() {
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

  Future<Response> fetchLocation(String vin) {
    return get('/$vin/location');
  }
}
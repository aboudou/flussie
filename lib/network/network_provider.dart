import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NetworkProvider extends GetConnect {
  static final NetworkProvider _instance = NetworkProvider._internal();

  NetworkProvider._internal() {
    _clientSetup();
  }

  factory NetworkProvider() {
    return _instance;
  }

  void _clientSetup() {
    httpClient.baseUrl = 'https://api.tessie.com';

    httpClient.addRequestModifier<Object?>((request) {
      final token = GetStorage().read('token') ?? '';
      request.headers['Authorization'] = "Bearer $token";
      return request;
    });
  }

  Future<Response> fetchVehicles() {
    return get('/vehicles');
  }

}
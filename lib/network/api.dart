import 'package:flussie/models/vehicles.dart';
import 'package:flussie/network/network_provider.dart';

class Api {

  static final Api _instance = Api._internal();

  Api._internal();

  factory Api() {
    return _instance;
  }

  final NetworkProvider _networkProvider = NetworkProvider();

  Future<List<VehicleResult>?> getVehicles() async {
    final response = await _networkProvider.fetchVehicles();

    if (response.status.hasError) {
      throw Exception('Failed to load vehicles: ${response.statusText}');
    }

    return Vehicles.fromJson(response.body as Map<String, dynamic>).vehicles;
  }
}
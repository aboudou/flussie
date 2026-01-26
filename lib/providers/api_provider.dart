import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flussie/misc/constants.dart';
import 'package:flussie/models/location.dart';
import 'package:flussie/models/vehicles.dart';
import 'package:flussie/providers/network_provider.dart';

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
  
  Future<Location> getLocation(String vin) async {
    final response = await _networkProvider.fetchLocation(vin);

    if (response.status.hasError) {
      throw Exception('Failed to load location for $vin: ${response.statusText}');
    }

    return Location.fromJson(response.body as Map<String, dynamic>);
  }

  Image getMapImage(String vin, {int width = 100, int height = 100, int zoom = 13}) {
    final token = GetStorage().read(Constants.tokenStorageKey) ?? '';
    return Image.network( 
      '${Constants.apiBaseUrl}/$vin/map?width=$width&height=$height&zoom=$zoom&marker_size=25&style=light',
      width: width.toDouble(),
      height: height.toDouble(),
      headers: {
        'Authorization': 'Bearer $token',
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width.toDouble(),
          height: height.toDouble(),
          color: Colors.transparent,
          child: const Icon(Icons.location_off, size: 50, color: Colors.red),
        );
      },
    );
  }

}
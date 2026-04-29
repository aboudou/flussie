import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';


class JsonLocalProvider extends GetConnect {
  static final JsonLocalProvider _instance = JsonLocalProvider._internal();

  JsonLocalProvider._internal();

  factory JsonLocalProvider() {
    return _instance;
  }

  Future<Response> fetchVehicles() async {
    return _response(await rootBundle.loadString('assets/json/vehicles.json'));
  }

  Future<Response> fetchVehicle() async {
    return _response(await rootBundle.loadString('assets/json/vehicle.json'));
  }
  //   return get('/$vin/state');
  // }

  Future<Response> fetchLocation() async {
    return _response(await rootBundle.loadString('assets/json/location.json'));
  }

  Future<Response> fetchBatteryHealth() async {
    return _response(await rootBundle.loadString('assets/json/battery_health.json'));
  }

  Future<Response> fetchCharges(bool superchargersOnly) async {
    return _response(await rootBundle.loadString(superchargersOnly
        ? 'assets/json/charges_suc_only.json'
        : 'assets/json/charges_all.json'));
  }

  Future<Response> fetchDrives() async {
    return _response(await rootBundle.loadString('assets/json/drives.json'));
  }

  Future<Response> fetchPath(int startDate) async {
    return _response(await rootBundle.loadString('assets/json/path_$startDate.json'));
  }

  Future<Response> _response(String data) async {
    return Response(
      body: jsonDecode(data),
      statusCode: 200,
    );
  }
}
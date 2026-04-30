import 'dart:convert';

import 'package:flussie/providers/json/json_provider.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class JsonLocalProvider implements JsonProvider {
  static final JsonLocalProvider _instance = JsonLocalProvider._internal();

  JsonLocalProvider._internal();

  factory JsonLocalProvider() {
    return _instance;
  }

  @override
  Future<Response> fetchVehicles() async {
    return _response(await rootBundle.loadString('assets/json/vehicles.json'));
  }

  @override
  Future<Response> fetchVehicle(String vin) async {
    return _response(await rootBundle.loadString('assets/json/vehicle.json'));
  }

  @override
  Future<Response> fetchLocation(String vin) async {
    return _response(await rootBundle.loadString('assets/json/location.json'));
  }

  @override
  Future<Response> fetchBatteryHealth() async {
    return _response(await rootBundle.loadString('assets/json/battery_health.json'));
  }

  @override
  Future<Response> fetchCharges(String vin, bool superchargersOnly, int startDate, int endDate) async {
    return _response(await rootBundle.loadString(superchargersOnly
        ? 'assets/json/charges_suc_only.json'
        : 'assets/json/charges_all.json'));
  }

  @override
  Future<Response> fetchDrives(String vin, int startDate, int endDate) async {
    return _response(await rootBundle.loadString('assets/json/drives.json'));
  }

  @override
  Future<Response> fetchPath(String vin, int startDate, int endDate) async {
    return _response(await rootBundle.loadString('assets/json/path_$startDate.json'));
  }

  Future<Response> _response(String data) async {
    return Response(
      body: jsonDecode(data),
      statusCode: 200,
    );
  }
}
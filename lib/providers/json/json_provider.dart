import 'package:get/get.dart';

abstract class JsonProvider {
  Future<Response> fetchVehicles();
  Future<Response> fetchVehicle(String vin);
  Future<Response> fetchLocation(String vin);
  Future<Response> fetchBatteryHealth();
  Future<Response> fetchCharges(String vin, bool superchargersOnly, int startDate, int endDate);
  Future<Response> fetchDrives(String vin, int startDate, int endDate);
  Future<Response> fetchPath(String vin, int startDate, int endDate);
}
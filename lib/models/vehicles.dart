import 'vehicle.dart';

class Vehicles {
  final List<VehicleResult>? vehicles;

  const Vehicles({this.vehicles});

  factory Vehicles.fromJson(Map<String, dynamic> json) {
    final raw = json['results'];

    if (raw == null) {
      return Vehicles(vehicles: null);
    }

    final list = raw as List;

    return Vehicles(
      vehicles: list
          .whereType<Map<String, dynamic>>()
          .map((e) => VehicleResult.fromJson(e))
          .toList(),
    );
  }
}

class VehicleResult {
  final String? vin;
  final bool? isActive;
  final Vehicle? vehicle;

  const VehicleResult({
    this.vin,
    this.isActive,
    this.vehicle,
  });

  factory VehicleResult.fromJson(Map<String, dynamic> json) {
    return VehicleResult(
      vin: json['vin'] as String?,
      isActive: json['is_active'] as bool?,
      vehicle: json['last_state'] == null ? null : Vehicle.fromJson(json['last_state'] as Map<String, dynamic>),
    );
  }
}

import 'vehicle.dart';

class VehicleList {
  final List<VehicleListItem>? vehicles;

  const VehicleList({this.vehicles});

  factory VehicleList.fromJson(Map<String, dynamic> json) {
    final raw = json['results'];

    if (raw == null) {
      return VehicleList(vehicles: null);
    }

    final list = raw as List;

    return VehicleList(
      vehicles: list
          .whereType<Map<String, dynamic>>()
          .map((e) => VehicleListItem.fromJson(e))
          .toList(),
    );
  }
}

class VehicleListItem {
  final String? vin;
  final bool? isActive;
  final Vehicle? vehicle;

  const VehicleListItem({
    this.vin,
    this.isActive,
    this.vehicle,
  });

  factory VehicleListItem.fromJson(Map<String, dynamic> json) {
    return VehicleListItem(
      vin: json['vin'] as String?,
      isActive: json['is_active'] as bool?,
      vehicle: json['last_state'] == null ? null : Vehicle.fromJson(json['last_state'] as Map<String, dynamic>),
    );
  }
}

class BatteryHealthList {
  final List<BatteryHealth>? results;

  const BatteryHealthList({this.results});

  factory BatteryHealthList.fromJson(Map<String, dynamic> json) {
    final raw = json['results'];

    if (raw == null) {
      return BatteryHealthList(results: null);
    }

    final list = raw as List;

    return BatteryHealthList(
      results: list
          .whereType<Map<String, dynamic>>()
          .map((e) => BatteryHealth.fromJson(e))
          .toList(),
    );
  }
}

class BatteryHealth {
  BatteryHealth({
    required this.vin,
    required this.plate,
    required this.odometer,
    required this.maxRange,
    required this.maxIdealRange,
    required this.capacity,
    required this.originalCapacity,
    required this.degradationPercent,
    required this.healthPercent,
  });

  final String? vin;
  final String? plate;
  final double? odometer;
  final double? maxRange;
  final double? maxIdealRange;
  final double? capacity;
  final double? originalCapacity;
  final double? degradationPercent;
  final double? healthPercent;

  factory BatteryHealth.fromJson(Map<String, dynamic> json) {
    return BatteryHealth(
      vin: json['vin'],
      plate: json['plate'],
      odometer: (json['odometer'] as num?)?.toDouble(),
      maxRange: (json['max_range'] as num?)?.toDouble(),
      maxIdealRange: (json['max_ideal_range'] as num?)?.toDouble(),
      capacity: (json['capacity'] as num?)?.toDouble(),
      originalCapacity: (json['original_capacity'] as num?)?.toDouble(),
      degradationPercent: (json['degradation_percent'] as num?)?.toDouble(),
      healthPercent: (json['health_percent'] as num?)?.toDouble(),
    );
  }
}
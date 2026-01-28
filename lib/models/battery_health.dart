class BatteryHealth {
  final List<BatteryHealthResult>? results;

  const BatteryHealth({this.results});

  factory BatteryHealth.fromJson(Map<String, dynamic> json) {
    final raw = json['results'];

    if (raw == null) {
      return BatteryHealth(results: null);
    }

    final list = raw as List;

    return BatteryHealth(
      results: list
          .whereType<Map<String, dynamic>>()
          .map((e) => BatteryHealthResult.fromJson(e))
          .toList(),
    );
  }
}

class BatteryHealthResult {
  BatteryHealthResult({
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
  final int? maxRange;
  final double? maxIdealRange;
  final double? capacity;
  final double? originalCapacity;
  final double? degradationPercent;
  final double? healthPercent;

  factory BatteryHealthResult.fromJson(Map<String, dynamic> json) {
    return BatteryHealthResult(
      vin: json['vin'],
      plate: json['plate'],
      odometer: (json['odometer'] as num?)?.toDouble(),
      maxRange: json['max_range'],
      maxIdealRange: (json['max_ideal_range'] as num?)?.toDouble(),
      capacity: (json['capacity'] as num?)?.toDouble(),
      originalCapacity: (json['original_capacity'] as num?)?.toDouble(),
      degradationPercent: (json['degradation_percent'] as num?)?.toDouble(),
      healthPercent: (json['health_percent'] as num?)?.toDouble(),
    );
  }
}
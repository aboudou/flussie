class DriveList {
  final List<Drive> results;

  const DriveList({required this.results});

  factory DriveList.fromJson(Map<String, dynamic> json) {
    final raw = json['results'];

    if (raw == null) {
      return DriveList(results: []);
    }

    final list = raw as List;

    return DriveList(
      results: list
          .whereType<Map<String, dynamic>>()
          .map((e) => Drive.fromJson(e))
          .toList(),
    );
  }
}

class Drive {
  final int? id;
  final int? startedAt;
  final int? endedAt;
  final String? startingLocation;
  final String? startingSavedLocation;
  final double? startingLatitude;
  final double? startingLongitude;
  final double? startingOdometer;
  final String? endingLocation;
  final String? endingSavedLocation;
  final double? endingLatitude;
  final double? endingLongitude;
  final double? endingOdometer;
  final int? startingBattery;
  final int? endingBattery;
  final double? averageInsideTemperature;
  final double? averageOutsideTemperature;
  final double? averageSpeed;
  final double? maxSpeed;
  final double? ratedRangeUsed;
  final double? idealRangeUsed;
  final double? odometerDistance;
  final double? autopilotDistance;
  final double? energyUsed;

  const Drive({
    this.id,
    this.startedAt,
    this.endedAt,
    this.startingLocation,
    this.startingSavedLocation,
    this.startingLatitude,
    this.startingLongitude,
    this.startingOdometer,
    this.endingLocation,
    this.endingSavedLocation,
    this.endingLatitude,
    this.endingLongitude,
    this.endingOdometer,
    this.startingBattery,
    this.endingBattery,
    this.averageInsideTemperature,
    this.averageOutsideTemperature,
    this.averageSpeed,
    this.maxSpeed,
    this.ratedRangeUsed,
    this.idealRangeUsed,
    this.odometerDistance,
    this.autopilotDistance,
    this.energyUsed,
  });

  factory Drive.fromJson(Map<String, dynamic> json) {
    return Drive(
      id: json['id'] as int?,
      startedAt: json['started_at'] as int?,
      endedAt: json['ended_at'] as int?,
      startingLocation: json['starting_location'] as String?,
      startingSavedLocation: json['starting_saved_location'] as String?,
      startingLatitude: (json['starting_latitude'] as num?)?.toDouble(),
      startingLongitude: (json['starting_longitude'] as num?)?.toDouble(),
      startingOdometer: (json['starting_odometer'] as num?)?.toDouble(),
      endingLocation: json['ending_location'] as String?,
      endingSavedLocation: json['ending_saved_location'] as String?,
      endingLatitude: (json['ending_latitude'] as num?)?.toDouble(),
      endingLongitude: (json['ending_longitude'] as num?)?.toDouble(),
      endingOdometer: (json['ending_odometer'] as num?)?.toDouble(),
      startingBattery: json['starting_battery'] as int?,
      endingBattery: json['ending_battery'] as int?,
      averageInsideTemperature: (json['average_inside_temperature'] as num?)?.toDouble(),
      averageOutsideTemperature: (json['average_outside_temperature'] as num?)?.toDouble(),
      averageSpeed: (json['average_speed'] as num?)?.toDouble(),
      maxSpeed: (json['max_speed'] as num?)?.toDouble(),
      ratedRangeUsed: (json['rated_range_used'] as num?)?.toDouble(),
      idealRangeUsed: (json['ideal_range_used'] as num?)?.toDouble(),
      odometerDistance: (json['odometer_distance'] as num?)?.toDouble(),
      autopilotDistance: (json['autopilot_distance'] as num?)?.toDouble(),
      energyUsed: (json['energy_used'] as num?)?.toDouble(),
    );
  }
}

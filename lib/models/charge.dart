class ChargeList {
  final List<Charge> results;

  const ChargeList({required this.results});

  factory ChargeList.fromJson(Map<String, dynamic> json) {
    final raw = json['results'];

    if (raw == null) {
      return ChargeList(results: []);
    }

    final list = raw as List;

    return ChargeList(
      results: list
          .whereType<Map<String, dynamic>>()
          .map((e) => Charge.fromJson(e))
          .toList(),
    );
  }
}

class Charge {
  final int? id;
  final int? startedAt;
  final int? endedAt;
  final String? location;
  final String? savedLocation;
  final double? latitude;
  final double? longitude;
  final bool? isSupercharger;
  final bool? isFastCharger;
  final double? odometer;
  final double? energyAdded;
  final double? energyUsed;
  final double? milesAdded;
  final double? milesAddedIdeal;
  final int? startingBattery;
  final int? endingBattery;
  final double? maxRange;
  final double? maxIdealRange;
  final double? capacity;
  final double? cost;
  final double? sinceLastCharge;

  const Charge({
    this.id,
    this.startedAt,
    this.endedAt,
    this.location,
    this.savedLocation,
    this.latitude,
    this.longitude,
    this.isSupercharger,
    this.isFastCharger,
    this.odometer,
    this.energyAdded,
    this.energyUsed,
    this.milesAdded,
    this.milesAddedIdeal,
    this.startingBattery,
    this.endingBattery,
    this.maxRange,
    this.maxIdealRange,
    this.capacity,
    this.cost,
    this.sinceLastCharge,
  });

  factory Charge.fromJson(Map<String, dynamic> json) {
    return Charge(
      id: json['id'] as int?,
      startedAt: json['started_at'] as int?,
      endedAt: json['ended_at'] as int?,
      location: json['location'] as String?,
      savedLocation: json['saved_location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isSupercharger: json['is_supercharger'] as bool?,
      isFastCharger: json['is_fast_charger'] as bool?,
      odometer: (json['odometer'] as num?)?.toDouble(),
      energyAdded: (json['energy_added'] as num?)?.toDouble(),
      energyUsed: (json['energy_used'] as num?)?.toDouble(),
      milesAdded: (json['miles_added'] as num?)?.toDouble(),
      milesAddedIdeal: (json['miles_added_ideal'] as num?)?.toDouble(),
      startingBattery: json['starting_battery'] as int?,
      endingBattery: json['ending_battery'] as int?,
      maxRange: (json['max_range'] as num?)?.toDouble(),
      maxIdealRange: (json['max_ideal_range'] as num?)?.toDouble(),
      capacity: (json['capacity'] as num?)?.toDouble(),
      cost: (json['cost'] as num?)?.toDouble(),
      sinceLastCharge: (json['since_last_charge'] as num?)?.toDouble(),
    );
  }
}
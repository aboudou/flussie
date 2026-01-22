class Location {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? savedLocation;

  Location({
    this.latitude,
    this.longitude,
    this.address,
    this.savedLocation,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address'] as String?,
      savedLocation: json['saved_location'] as String?,
    );
  }
}
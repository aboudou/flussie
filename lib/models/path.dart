import 'package:latlong2/latlong.dart';

class Path {
  final List<LatLng> results;

  const Path({required this.results});

  factory Path.fromJson(Map<String, dynamic> json) {
    final raw = json['results'];

    if (raw == null) {
      return Path(results: []);
    }

    final list = raw as List;

    return Path(
      results: list
          .whereType<String>()
          .map((e) {
            final parts = e.split(',');
            return LatLng(double.parse(parts[0]), double.parse(parts[1]));
          })
          .toList(),
    );
  }
}

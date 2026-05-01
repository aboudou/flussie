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
            try {
              final parts = e.split(',');
              if (parts.length < 2) return null;
              return LatLng(double.parse(parts[0].trim()), double.parse(parts[1].trim()));
            } catch (_) {
              return null;
            }
          })
          .whereType<LatLng>()
          .toList(),
    );
  }
}

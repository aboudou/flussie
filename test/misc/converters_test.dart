import 'package:flutter_test/flutter_test.dart';
import 'package:flussie/misc/converters.dart';

void main() {
  group('Converters.milesToKm', () {
    test('converts 1 mile correctly', () {
      expect(Converters.milesToKm(1.0), closeTo(1.60934, 0.0001));
    });

    test('returns 0.0 for 0 miles', () {
      expect(Converters.milesToKm(0.0), equals(0.0));
    });

    test('returns 0.0 for null', () {
      expect(Converters.milesToKm(null), equals(0.0));
    });

    test('scales linearly', () {
      expect(Converters.milesToKm(100.0), closeTo(160.934, 0.01));
    });
  });
}

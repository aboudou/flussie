import 'dart:typed_data';

abstract class BinaryProvider {
  Future<Uint8List> fetchMap(String vin, {int width = 100, int height = 100, int zoom = 13});
}
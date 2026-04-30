import 'package:flutter/services.dart';
import 'package:flussie/providers/binary/binary_provider.dart';

class BinaryLocalProvider implements BinaryProvider {
  static final BinaryLocalProvider _instance = BinaryLocalProvider._internal();

  BinaryLocalProvider._internal();

  factory BinaryLocalProvider() {
    return _instance;
  }

  @override
  Future<Uint8List> fetchMap(String vin, {int width = 100, int height = 100, int zoom = 13}) async {
    final data = await rootBundle.load('assets/images/map.png');
    return data.buffer.asUint8List();
  }
}
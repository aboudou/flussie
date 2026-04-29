import 'package:flutter/services.dart';

class BinaryLocalProvider {
  static final BinaryLocalProvider _instance = BinaryLocalProvider._internal();

  BinaryLocalProvider._internal();

  factory BinaryLocalProvider() {
    return _instance;
  }

  Future<Uint8List> fetchMap() async {
    final data = await rootBundle.load('assets/images/map.png');
    return data.buffer.asUint8List();
  }
}
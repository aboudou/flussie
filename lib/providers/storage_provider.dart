import 'dart:ui';

import 'package:get_storage/get_storage.dart';

import 'package:flussie/misc/constants.dart';

class StorageProvider {
  static final StorageProvider _instance = StorageProvider._internal();

  StorageProvider._internal();

  factory StorageProvider() {
    return _instance;
  }

  final GetStorage box = GetStorage();

  String? getToken() {
    return box.read(Constants.tokenStorageKey);
  }

  Future<void> saveToken(String token) async {
    await box.write(Constants.tokenStorageKey, token);
  }

  Future<void> deleteToken() async {
    await box.remove(Constants.tokenStorageKey);
  }

  VoidCallback addListener(Function() callback) {
    return box.listen(() {
      callback();
    });
  }

  void listenToken(Function(dynamic) callback) {
    box.listenKey(Constants.tokenStorageKey, (value) {
      callback(value);
    });
  }
}
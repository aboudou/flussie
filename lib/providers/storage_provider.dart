import 'package:flutter_keychain/flutter_keychain.dart';

import 'package:flussie/misc/constants.dart';

class StorageProvider {
  static final StorageProvider _instance = StorageProvider._internal();

  StorageProvider._internal();

  factory StorageProvider() {
    return _instance;
  }

  Future<String?> getToken() async {
    return await FlutterKeychain.get(key: Constants.tokenStorageKey);
  }

  Future<void> saveToken(String token) async {
    await FlutterKeychain.put(key: Constants.tokenStorageKey, value: token);
  }

  Future<void> deleteToken() async {
    await FlutterKeychain.remove(key: Constants.tokenStorageKey);
  }

  // VoidCallback addListener(Function() callback) {
  //   return box.listen(() {
  //     callback();
  //   });
  // }

  // void listenToken(Function(dynamic) callback) {
  //   box.listenKey(Constants.tokenStorageKey, (value) {
  //     callback(value);
  //   });
  // }
}
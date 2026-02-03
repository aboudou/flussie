import 'dart:typed_data';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
 
import 'package:flussie/misc/constants.dart';

class BinaryNetworkProvider {
  static final BinaryNetworkProvider _instance = BinaryNetworkProvider._internal();

  BinaryNetworkProvider._internal();

  factory BinaryNetworkProvider() {
    return _instance;
  }

  Future<Uint8List> fetchMap(String vin, {int width = 100, int height = 100, int zoom = 13}) async {
    final url = Uri.parse('${Constants.apiBaseUrl}/$vin/map?width=$width&height=$height&zoom=$zoom&marker_size=25&style=light',);
    final token = GetStorage().read(Constants.tokenStorageKey) ?? '';

    var response = await http.get(url, headers: {'Authorization': 'Bearer $token'},);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw('Failed to load map image for $vin: ${response.statusCode}');
    }
  }
}
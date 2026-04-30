import 'package:flussie/providers/api/api_provider.dart';
import 'package:flussie/providers/storage/storage_provider.dart';
import 'package:flussie/providers/json/json_network_provider.dart';
import 'package:flussie/providers/binary/binary_network_provider.dart';
import 'package:flussie/providers/json/json_local_provider.dart';
import 'package:flussie/providers/binary/binary_local_provider.dart';

class Providers {
  final ApiProvider apiProvider = ApiProvider();
  final StorageProvider storageProvider = StorageProvider();

  // Providers for network API calls
  final JsonNetworkProvider jsonNetworkProvider = JsonNetworkProvider();
  final BinaryNetworkProvider binaryNetworkProvider = BinaryNetworkProvider();

  // Providers for local JSON files for demo mode
  final JsonLocalProvider jsonLocalProvider = JsonLocalProvider();
  final BinaryLocalProvider binaryLocalProvider = BinaryLocalProvider();
}
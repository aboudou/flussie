import 'package:flussie/providers/storage_provider.dart';

class TokenSetterViewModel {
  final StorageProvider _storageProvider = StorageProvider();

  Future<void> saveToken(String token) async {
    await _storageProvider.saveToken(token);
  }
}
import 'package:flussie/providers/storage/storage_provider.dart';

class TokenSetterViewModel {
  TokenSetterViewModel({required StorageProvider storageProvider}) : _storageProvider = storageProvider;

  final StorageProvider _storageProvider;

  Future<void> saveToken(String token) async {
    await _storageProvider.saveToken(token);
  }
}
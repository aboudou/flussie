import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flussie/providers/storage/storage_provider.dart';
import 'package:flussie/viewmodels/token_setter_vm.dart';

class MockStorageProvider extends Mock implements StorageProvider {}

void main() {
  late MockStorageProvider mockStorage;
  late TokenSetterViewModel vm;

  setUp(() {
    mockStorage = MockStorageProvider();
    vm = TokenSetterViewModel(storageProvider: mockStorage);
  });

  group('TokenSetterViewModel.saveToken', () {
    test('delegates to storageProvider', () async {
      when(() => mockStorage.saveToken(any())).thenAnswer((_) async {});

      await vm.saveToken('abc123');

      verify(() => mockStorage.saveToken('abc123')).called(1);
    });

    test('passes the token value unchanged', () async {
      String? captured;
      when(() => mockStorage.saveToken(any())).thenAnswer((invocation) async {
        captured = invocation.positionalArguments[0] as String;
      });

      await vm.saveToken('my-tessie-token');

      expect(captured, equals('my-tessie-token'));
    });
  });
}

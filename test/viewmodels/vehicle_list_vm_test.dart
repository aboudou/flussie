import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flussie/models/location.dart';
import 'package:flussie/models/vehicles.dart';
import 'package:flussie/providers/api/api_provider.dart';
import 'package:flussie/providers/storage/storage_provider.dart';
import 'package:flussie/viewmodels/vehicle_list_vm.dart';

class MockStorageProvider extends Mock implements StorageProvider {}

class MockApiProvider extends Mock implements ApiProvider {}

void main() {
  late MockStorageProvider mockStorage;
  late MockApiProvider mockApi;
  late VehicleListViewModel vm;

  setUp(() {
    mockStorage = MockStorageProvider();
    mockApi = MockApiProvider();
    vm = VehicleListViewModel(storageProvider: mockStorage, apiProvider: mockApi);
  });

  tearDown(() => vm.dispose());

  group('getToken', () {
    test('sets isLoggedIn and token when a token exists', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => 'abc123');

      await vm.getToken();

      expect(vm.isLoggedIn.value, isTrue);
      expect(vm.token.value, equals('abc123'));
    });

    test('sets isLoggedIn to false when no token', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => null);

      await vm.getToken();

      expect(vm.isLoggedIn.value, isFalse);
      expect(vm.token.value, isEmpty);
    });

    test('sets isLoggedIn to false for empty string token', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => '');

      await vm.getToken();

      expect(vm.isLoggedIn.value, isFalse);
    });
  });

  group('deleteToken', () {
    test('clears all state', () async {
      when(() => mockStorage.deleteToken()).thenAnswer((_) async {});
      vm.token.value = 'abc123';
      vm.isLoggedIn.value = true;
      vm.vehicles.add(const VehicleListItem(vin: 'VIN1'));
      vm.errorMessage.value = 'some error';

      await vm.deleteToken();

      expect(vm.isLoggedIn.value, isFalse);
      expect(vm.token.value, isEmpty);
      expect(vm.vehicles, isEmpty);
      expect(vm.errorMessage.value, isEmpty);
    });
  });

  group('refreshVehiclesList', () {
    test('populates vehicles on success', () async {
      final items = [
        const VehicleListItem(vin: 'VIN1'),
        const VehicleListItem(vin: 'VIN2'),
      ];
      when(() => mockApi.getVehicles()).thenAnswer((_) async => items);
      when(() => mockApi.getLocation(any())).thenAnswer((_) async => Location(address: 'Paris'));
      when(() => mockApi.getMapImage(any())).thenAnswer((_) async => Uint8List(0));

      await vm.refreshVehiclesList();

      expect(vm.vehicles.length, equals(2));
      expect(vm.errorMessage.value, isEmpty);
    });

    test('clears vehicles and sets errorMessage on failure', () async {
      vm.vehicles.add(const VehicleListItem(vin: 'OLD'));
      when(() => mockApi.getVehicles()).thenThrow(Exception('network error'));

      await vm.refreshVehiclesList();

      expect(vm.vehicles, isEmpty);
      expect(vm.errorMessage.value, isNotEmpty);
    });

    test('clears errorMessage on success', () async {
      vm.errorMessage.value = 'previous error';
      when(() => mockApi.getVehicles()).thenAnswer((_) async => []);

      await vm.refreshVehiclesList();

      expect(vm.errorMessage.value, isEmpty);
    });
  });

  group('refreshVehicle', () {
    test('runs location and map fetches in parallel', () async {
      when(() => mockApi.getLocation(any()))
          .thenAnswer((_) async => Location(address: '1 Rue de Paris'));
      when(() => mockApi.getMapImage(any()))
          .thenAnswer((_) async => Uint8List(0));

      await vm.refreshVehicle('VIN1');

      verify(() => mockApi.getLocation('VIN1')).called(1);
      verify(() => mockApi.getMapImage('VIN1')).called(1);
    });

    test('updates location from API response', () async {
      when(() => mockApi.getLocation(any()))
          .thenAnswer((_) async => Location(address: '42 Avenue Montaigne'));
      when(() => mockApi.getMapImage(any()))
          .thenAnswer((_) async => Uint8List(0));

      await vm.refreshVehicle('VIN1');

      expect(vm.location.value, equals('42 Avenue Montaigne'));
    });
  });
}

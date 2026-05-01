import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flussie/enums/charge_type.dart';
import 'package:flussie/models/charge.dart';
import 'package:flussie/providers/api/api_provider.dart';
import 'package:flussie/viewmodels/charge_list_vm.dart';

class MockApiProvider extends Mock implements ApiProvider {}

void main() {
  late MockApiProvider mockApi;
  late ChargeListViewModel vm;

  setUp(() {
    mockApi = MockApiProvider();
    when(() => mockApi.getCharges(any(), any(), any(), any()))
        .thenAnswer((_) async => const ChargeList(results: []));
    vm = ChargeListViewModel(vin: 'TEST_VIN', apiProvider: mockApi);
  });

  tearDown(() => vm.dispose());

  group('refresh', () {
    test('populates chargeList on success', () async {
      final charges = [
        const Charge(id: 1, isSupercharger: true),
        const Charge(id: 2, isFastCharger: true),
      ];
      when(() => mockApi.getCharges(any(), any(), any(), any()))
          .thenAnswer((_) async => ChargeList(results: charges));

      await vm.refresh();

      expect(vm.chargeList.value.results.length, equals(2));
      expect(vm.errorMessage.value, isEmpty);
    });

    test('sets errorMessage on failure', () async {
      when(() => mockApi.getCharges(any(), any(), any(), any()))
          .thenThrow(Exception('API error'));

      await vm.refresh();

      expect(vm.chargeList.value.results, isEmpty);
      expect(vm.errorMessage.value, isNotEmpty);
    });

    test('clears errorMessage on success after a previous failure', () async {
      vm.errorMessage.value = 'previous error';
      when(() => mockApi.getCharges(any(), any(), any(), any()))
          .thenAnswer((_) async => const ChargeList(results: []));

      await vm.refresh();

      expect(vm.errorMessage.value, isEmpty);
    });
  });

  group('getStationType', () {
    test('returns supercharger when isSupercharger is true', () {
      expect(
        vm.getStationType(const Charge(isSupercharger: true)),
        equals(ChargeType.supercharger),
      );
    });

    test('returns fastCharger when isFastCharger is true', () {
      expect(
        vm.getStationType(const Charge(isFastCharger: true)),
        equals(ChargeType.fastCharger),
      );
    });

    test('returns standardCharger by default', () {
      expect(
        vm.getStationType(const Charge()),
        equals(ChargeType.standardCharger),
      );
    });
  });

  group('getDuration', () {
    test('formats hours and minutes', () {
      final charge = Charge(
        startedAt: 1_000_000,
        endedAt: 1_000_000 + 3 * 3600 + 45 * 60,
      );
      expect(vm.getDuration(charge), equals('3h 45m'));
    });

    test('formats minutes only when under 1 hour', () {
      final charge = Charge(
        startedAt: 1_000_000,
        endedAt: 1_000_000 + 30 * 60,
      );
      expect(vm.getDuration(charge), equals('30m'));
    });

    test('returns empty string for zero duration', () {
      final charge = Charge(startedAt: 1_000_000, endedAt: 1_000_000);
      expect(vm.getDuration(charge), equals(''));
    });
  });

  group('getChargeLocation', () {
    test('prefers savedLocation over location', () {
      final charge = Charge(location: 'API address', savedLocation: 'My Home');
      expect(vm.getChargeLocation(charge), equals('My Home'));
    });

    test('falls back to location when savedLocation is empty', () {
      final charge = Charge(location: 'API address', savedLocation: '');
      expect(vm.getChargeLocation(charge), equals('API address'));
    });
  });
}

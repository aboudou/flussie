import 'package:flutter_test/flutter_test.dart';
import 'package:flussie/enums/charge_type.dart';
import 'package:flussie/models/charge.dart';
import 'package:flussie/viewmodels/charge_details_vm.dart';

void main() {
  group('stationType', () {
    test('is supercharger when isSupercharger is true', () {
      final vm = ChargeDetailsViewModel(charge: const Charge(isSupercharger: true));
      expect(vm.stationType, equals(ChargeType.supercharger));
    });

    test('is fastCharger when isFastCharger is true and not supercharger', () {
      final vm = ChargeDetailsViewModel(charge: const Charge(isFastCharger: true));
      expect(vm.stationType, equals(ChargeType.fastCharger));
    });

    test('is standardCharger by default', () {
      final vm = ChargeDetailsViewModel(charge: const Charge());
      expect(vm.stationType, equals(ChargeType.standardCharger));
    });
  });

  group('location', () {
    test('uses savedLocation when not empty', () {
      final vm = ChargeDetailsViewModel(
        charge: const Charge(savedLocation: 'Home', location: 'Other'),
      );
      expect(vm.location, equals('Home'));
    });

    test('uses location when savedLocation is empty', () {
      final vm = ChargeDetailsViewModel(
        charge: const Charge(savedLocation: '', location: '42 Rue de la Paix'),
      );
      expect(vm.location, equals('42 Rue de la Paix'));
    });

    test('uses location when savedLocation is null', () {
      final vm = ChargeDetailsViewModel(
        charge: const Charge(location: '42 Rue de la Paix'),
      );
      expect(vm.location, equals('42 Rue de la Paix'));
    });

    test('falls back to translation key when both are null', () {
      final vm = ChargeDetailsViewModel(charge: const Charge());
      expect(vm.location, isNotEmpty);
    });
  });

  group('battery levels', () {
    test('startBatteryLevel formatted as percentage', () {
      final vm = ChargeDetailsViewModel(charge: const Charge(startingBattery: 20));
      expect(vm.startBatteryLevel, equals('20%'));
    });

    test('endBatteryLevel formatted as percentage', () {
      final vm = ChargeDetailsViewModel(charge: const Charge(endingBattery: 85));
      expect(vm.endBatteryLevel, equals('85%'));
    });

    test('startingBattery defaults to 0 when null', () {
      final vm = ChargeDetailsViewModel(charge: const Charge());
      expect(vm.startBatteryLevel, equals('0%'));
    });
  });

  group('coordinates', () {
    test('set from latitude and longitude', () {
      final vm = ChargeDetailsViewModel(
        charge: const Charge(latitude: 48.85, longitude: 2.35),
      );
      expect(vm.coordinates.latitude, closeTo(48.85, 0.001));
      expect(vm.coordinates.longitude, closeTo(2.35, 0.001));
    });

    test('remain at (0,0) when latitude/longitude are null', () {
      final vm = ChargeDetailsViewModel(charge: const Charge());
      expect(vm.coordinates.latitude, equals(0.0));
      expect(vm.coordinates.longitude, equals(0.0));
    });
  });

  group('distance formatting', () {
    test('odometer formatted with unit', () {
      final vm = ChargeDetailsViewModel(charge: const Charge(odometer: 50000.0));
      expect(vm.odometer, contains('km'));
    });

    test('distanceSinceLastCharge formatted with unit', () {
      final vm = ChargeDetailsViewModel(charge: const Charge(sinceLastCharge: 150.5));
      expect(vm.distanceSinceLastCharge, contains('km'));
    });

    test('odometer is N/A when null', () {
      final vm = ChargeDetailsViewModel(charge: const Charge());
      expect(vm.odometer, equals('N/A'));
    });
  });

  group('energy formatting', () {
    test('energyUsed formatted with unit', () {
      final vm = ChargeDetailsViewModel(charge: const Charge(energyUsed: 15.5));
      expect(vm.energyUsed, contains('kWh'));
    });

    test('energyAdded formatted with unit', () {
      final vm = ChargeDetailsViewModel(charge: const Charge(energyAdded: 12.0));
      expect(vm.energyAdded, contains('kWh'));
    });

    test('energyUsed is N/A when null', () {
      final vm = ChargeDetailsViewModel(charge: const Charge());
      expect(vm.energyUsed, equals('N/A'));
    });

    test('efficiency calculated from energyAdded/energyUsed', () {
      final vm = ChargeDetailsViewModel(
        charge: const Charge(energyAdded: 9.0, energyUsed: 10.0),
      );
      expect(vm.efficiency, contains('90'));
    });

    test('efficiency is N/A when energyUsed is null', () {
      final vm = ChargeDetailsViewModel(charge: const Charge(energyAdded: 9.0));
      expect(vm.efficiency, equals('N/A'));
    });

    test('efficiency is N/A when energyUsed is zero', () {
      final vm = ChargeDetailsViewModel(
        charge: const Charge(energyAdded: 9.0, energyUsed: 0),
      );
      expect(vm.efficiency, equals('N/A'));
    });
  });

  group('cost formatting', () {
    test('cost formatted with currency symbol', () {
      final vm = ChargeDetailsViewModel(charge: const Charge(cost: 4.5));
      expect(vm.cost, contains('€'));
    });

    test('cost is N/A when null', () {
      final vm = ChargeDetailsViewModel(charge: const Charge());
      expect(vm.cost, equals('N/A'));
    });
  });

  group('dates', () {
    test('startBatteryDate is non-empty when startedAt is set', () {
      final vm = ChargeDetailsViewModel(
        charge: const Charge(startedAt: 1700000000),
      );
      expect(vm.startBatteryDate, isNotEmpty);
    });

    test('startBatteryDate is empty when startedAt is null', () {
      final vm = ChargeDetailsViewModel(charge: const Charge());
      expect(vm.startBatteryDate, isEmpty);
    });

    test('endBatteryDate is non-empty when endedAt is set', () {
      final vm = ChargeDetailsViewModel(
        charge: const Charge(endedAt: 1700003600),
      );
      expect(vm.endBatteryDate, isNotEmpty);
    });
  });
}

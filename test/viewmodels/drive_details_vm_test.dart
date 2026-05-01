import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:flussie/models/drive.dart';
import 'package:flussie/viewmodels/drive_details_vm.dart';

DriveDetailsViewModel _vm(Drive drive) =>
    DriveDetailsViewModel(vin: 'VIN1', drive: drive, coordinates: []);

void main() {
  group('start location', () {
    test('uses startingSavedLocation when set', () {
      final vm = _vm(const Drive(
        startingSavedLocation: 'Home',
        startingLocation: 'Other',
      ));
      expect(vm.startLocation, equals('Home'));
    });

    test('falls back to startingLocation when savedLocation is empty', () {
      final vm = _vm(const Drive(
        startingSavedLocation: '',
        startingLocation: '42 Rue de la Paix',
      ));
      expect(vm.startLocation, equals('42 Rue de la Paix'));
    });

    test('falls back to startingLocation when savedLocation is null', () {
      final vm = _vm(const Drive(startingLocation: '42 Rue de la Paix'));
      expect(vm.startLocation, equals('42 Rue de la Paix'));
    });

    test('falls back to translation key when both are null', () {
      final vm = _vm(const Drive());
      expect(vm.startLocation, isNotEmpty);
    });
  });

  group('end location', () {
    test('uses endingSavedLocation when set', () {
      final vm = _vm(const Drive(
        endingSavedLocation: 'Work',
        endingLocation: 'Other',
      ));
      expect(vm.endLocation, equals('Work'));
    });

    test('falls back to endingLocation when savedLocation is empty', () {
      final vm = _vm(const Drive(
        endingSavedLocation: '',
        endingLocation: '1 Place Vendôme',
      ));
      expect(vm.endLocation, equals('1 Place Vendôme'));
    });

    test('falls back to translation key when both are null', () {
      final vm = _vm(const Drive());
      expect(vm.endLocation, isNotEmpty);
    });
  });

  group('battery levels', () {
    test('startBatteryLevel formatted as percentage', () {
      final vm = _vm(const Drive(startingBattery: 75));
      expect(vm.startBatteryLevel, equals('75%'));
    });

    test('endBatteryLevel formatted as percentage', () {
      final vm = _vm(const Drive(endingBattery: 55));
      expect(vm.endBatteryLevel, equals('55%'));
    });

    test('startBatteryLevel defaults to 0% when null', () {
      final vm = _vm(const Drive());
      expect(vm.startBatteryLevel, equals('0%'));
    });
  });

  group('drive distance', () {
    test('formatted with two decimal places and km unit', () {
      final vm = _vm(const Drive(odometerDistance: 50.5));
      expect(vm.driveDistance, equals('50.50 km'));
    });

    test('is empty when odometerDistance is null', () {
      final vm = _vm(const Drive());
      expect(vm.driveDistance, isEmpty);
    });
  });

  group('drive duration', () {
    test('formatted as hh:mm:ss', () {
      final vm = _vm(const Drive(startedAt: 1000, endedAt: 4600));
      expect(vm.driveDuration, equals('01:00:00'));
    });

    test('pads single-digit hours and minutes', () {
      final vm = _vm(const Drive(startedAt: 0, endedAt: 3661)); // 1h 1m 1s
      expect(vm.driveDuration, equals('01:01:01'));
    });

    test('is empty when startedAt or endedAt is null', () {
      final vm = _vm(const Drive(startedAt: 1000));
      expect(vm.driveDuration, isEmpty);
    });
  });

  group('energy', () {
    test('energyUsed formatted with two decimals and kWh unit', () {
      final vm = _vm(const Drive(energyUsed: 5.5));
      expect(vm.energyUsed, equals('5.50 kWh'));
    });

    test('energyUsed is empty when null', () {
      final vm = _vm(const Drive());
      expect(vm.energyUsed, isEmpty);
    });

    test('energyUsedPerKm calculated and formatted as Wh/km', () {
      // energyUsed=5.5 kWh, distance=50.0 km → (5500 Wh / 50 km) = 110 Wh/km
      final vm = _vm(const Drive(energyUsed: 5.5, odometerDistance: 50.0));
      expect(vm.energyUsedPerKm, equals('110 Wh/km'));
    });

    test('energyUsedPerKm is empty when distance is zero', () {
      final vm = _vm(const Drive(energyUsed: 5.5, odometerDistance: 0.0));
      expect(vm.energyUsedPerKm, isEmpty);
    });

    test('energyUsedPerKm is empty when energyUsed is null', () {
      final vm = _vm(const Drive(odometerDistance: 50.0));
      expect(vm.energyUsedPerKm, isEmpty);
    });
  });

  group('speed', () {
    test('averageSpeed formatted as km/h', () {
      final vm = _vm(const Drive(averageSpeed: 90.5));
      expect(vm.averageSpeed, equals('91 km/h'));
    });

    test('maxSpeed formatted as km/h', () {
      final vm = _vm(const Drive(maxSpeed: 120.0));
      expect(vm.maxSpeed, equals('120 km/h'));
    });

    test('averageSpeed is empty when null', () {
      final vm = _vm(const Drive());
      expect(vm.averageSpeed, isEmpty);
    });
  });

  group('dates', () {
    test('startDriveDate is non-empty when startedAt is set', () {
      final vm = _vm(const Drive(startedAt: 1700000000));
      expect(vm.startDriveDate, isNotEmpty);
    });

    test('startDriveDate is empty when startedAt is null', () {
      final vm = _vm(const Drive());
      expect(vm.startDriveDate, isEmpty);
    });

    test('endDriveDate is non-empty when endedAt is set', () {
      final vm = _vm(const Drive(endedAt: 1700003600));
      expect(vm.endDriveDate, isNotEmpty);
    });
  });

  group('coordinates', () {
    test('passed coordinates are stored', () {
      final coords = [LatLng(48.85, 2.35), LatLng(48.86, 2.36)];
      final vm = DriveDetailsViewModel(
        vin: 'VIN1',
        drive: const Drive(),
        coordinates: coords,
      );
      expect(vm.coordinates.length, equals(2));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flussie/models/battery_health.dart';
import 'package:flussie/models/location.dart';
import 'package:flussie/models/vehicle.dart';
import 'package:flussie/providers/api/api_provider.dart';
import 'package:flussie/viewmodels/vehicle_details_vm.dart';

class MockApiProvider extends Mock implements ApiProvider {}

void main() {
  late MockApiProvider mockApi;
  late VehicleDetailsViewModel vm;

  setUp(() {
    mockApi = MockApiProvider();
    when(() => mockApi.getVehicle(any())).thenAnswer((_) async => const Vehicle());
    when(() => mockApi.getLocation(any())).thenAnswer((_) async => Location());
    when(() => mockApi.getBatteryHealth()).thenAnswer((_) async => const BatteryHealthList());
    vm = VehicleDetailsViewModel(vin: 'VIN1', apiProvider: mockApi);
  });

  tearDown(() => vm.dispose());

  group('refresh', () {
    test('populates batteryLevel from chargeState', () async {
      when(() => mockApi.getVehicle(any())).thenAnswer((_) async => const Vehicle(
        chargeState: ChargeState(batteryLevel: 80),
      ));

      await vm.refresh();

      expect(vm.batteryLevel.value, equals(80));
    });

    test('populates batteryRange converted from miles to km', () async {
      when(() => mockApi.getVehicle(any())).thenAnswer((_) async => const Vehicle(
        chargeState: ChargeState(batteryRange: 100.0),
      ));

      await vm.refresh();

      expect(vm.batteryRange.value, equals(161)); // 100 miles * 1.60934 ≈ 161 km
    });

    test('sets location from getLocation response', () async {
      when(() => mockApi.getLocation(any()))
          .thenAnswer((_) async => Location(address: '42 Avenue Montaigne'));

      await vm.refresh();

      expect(vm.location.value, equals('42 Avenue Montaigne'));
    });

    test('sets state to charging when chargerActualCurrent is non-zero', () async {
      when(() => mockApi.getVehicle(any())).thenAnswer((_) async => const Vehicle(
        chargeState: ChargeState(chargerActualCurrent: 16),
      ));

      await vm.refresh();

      expect(vm.state.value, isNotEmpty);
    });

    test('sets state to driving when shiftState is not P and not charging', () async {
      when(() => mockApi.getVehicle(any())).thenAnswer((_) async => const Vehicle(
        driveState: DriveState(shiftState: 'D'),
        chargeState: ChargeState(chargerActualCurrent: 0),
      ));

      await vm.refresh();

      expect(vm.state.value, isNotEmpty);
    });

    test('sets chargePortState when chargePortDoorOpen is true', () async {
      when(() => mockApi.getVehicle(any())).thenAnswer((_) async => const Vehicle(
        chargeState: ChargeState(chargePortDoorOpen: true),
      ));

      await vm.refresh();

      expect(vm.chargePortState.value, isNotEmpty);
    });

    test('sets chargePortState when chargePortDoorOpen is false', () async {
      when(() => mockApi.getVehicle(any())).thenAnswer((_) async => const Vehicle(
        chargeState: ChargeState(chargePortDoorOpen: false),
      ));

      await vm.refresh();

      expect(vm.chargePortState.value, isNotEmpty);
    });

    test('populates batteryHealth and degradation for matching VIN', () async {
      when(() => mockApi.getBatteryHealth()).thenAnswer((_) async => BatteryHealthList(
        results: [
          BatteryHealth(
            vin: 'VIN1',
            plate: null,
            odometer: null,
            maxRange: null,
            maxIdealRange: null,
            capacity: null,
            originalCapacity: null,
            degradationPercent: 5.0,
            healthPercent: 95.0,
          ),
        ],
      ));

      await vm.refresh();

      expect(vm.batteryHealth.value, contains('95'));
      expect(vm.batteryDegradation.value, contains('5'));
    });

    test('sets batteryHealth to N/A when results is null', () async {
      when(() => mockApi.getBatteryHealth())
          .thenAnswer((_) async => const BatteryHealthList());

      await vm.refresh();

      expect(vm.batteryHealth.value, equals('N/A'));
      expect(vm.batteryDegradation.value, equals('N/A'));
    });

    test('sets odometer from vehicleState', () async {
      when(() => mockApi.getVehicle(any())).thenAnswer((_) async => const Vehicle(
        vehicleState: VehicleState(odometer: 10000.0),
      ));

      await vm.refresh();

      expect(vm.odometer.value, contains('km'));
    });

    test('sets coordinates from driveState latitude/longitude', () async {
      when(() => mockApi.getVehicle(any())).thenAnswer((_) async => const Vehicle(
        driveState: DriveState(latitude: 48.85, longitude: 2.35),
      ));

      await vm.refresh();

      expect(vm.coordinates.value.latitude, closeTo(48.85, 0.001));
      expect(vm.coordinates.value.longitude, closeTo(2.35, 0.001));
    });

    test('sets errorMessage on API failure', () async {
      when(() => mockApi.getVehicle(any())).thenThrow(Exception('network error'));

      await vm.refresh();

      expect(vm.errorMessage.value, isNotEmpty);
    });

    test('clears errorMessage on success after failure', () async {
      when(() => mockApi.getVehicle(any())).thenThrow(Exception('fail'));
      await vm.refresh();
      expect(vm.errorMessage.value, isNotEmpty);

      when(() => mockApi.getVehicle(any())).thenAnswer((_) async => const Vehicle());
      await vm.refresh();

      expect(vm.errorMessage.value, isEmpty);
    });
  });
}
